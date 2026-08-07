import Foundation
import Combine
import AVFoundation
import Vision
import CoreML

class CameraManager: NSObject, ObservableObject {
    // Quando estes valores mudam, a tela do diagnóstico é atualizada.
    @Published var currentDetection: DetectedComponent?
    @Published var statusMessage = "Aponte a câmera para um componente"
    @Published var errorMessage: String?

    // A CameraPreview usa esta sessão para mostrar a imagem da câmera.
    let session = AVCaptureSession()

    // A saída entrega cada imagem capturada para a função captureOutput.
    private let cameraOutput = AVCaptureVideoDataOutput()

    // O trabalho da câmera acontece fora da tela para não travar o aplicativo.
    private let cameraQueue = DispatchQueue(label: "blink.camera")
    private let components = MockData.electronicComponents

    // O Vision usa esta requisição para consultar o modelo Blink.mlmodel.
    private var classificationRequest: VNCoreMLRequest?
    private var cameraIsReady = false
    private var cameraShouldRun = false

    override init() {
        super.init()
        loadModel()
    }

    // Câmera

    func start() {
        cameraQueue.async { [weak self] in
            guard let self else { return }

            self.cameraShouldRun = true
            self.checkCameraPermission()
        }
    }

    func stop() {
        cameraQueue.async { [weak self] in
            guard let self else { return }

            self.cameraShouldRun = false

            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    private func checkCameraPermission() {
        let permission = AVCaptureDevice.authorizationStatus(for: .video)

        switch permission {
        case .authorized:
            startSession()

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] allowed in
                guard let self else { return }

                self.cameraQueue.async {
                    if allowed {
                        self.startSession()
                    } else {
                        self.showPermissionError()
                    }
                }
            }

        default:
            showPermissionError()
        }
    }

    private func startSession() {
        guard cameraShouldRun else { return }

        if !cameraIsReady {
            configureCamera()
        }

        if cameraIsReady && !session.isRunning {
            session.startRunning()
        }
    }

    private func configureCamera() {
        session.beginConfiguration()
        session.sessionPreset = .high

        guard
            let camera = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .back
            ),
            let cameraInput = try? AVCaptureDeviceInput(device: camera),
            session.canAddInput(cameraInput)
        else {
            session.commitConfiguration()
            showCameraError()
            return
        }

        session.addInput(cameraInput)

        cameraOutput.alwaysDiscardsLateVideoFrames = true
        cameraOutput.setSampleBufferDelegate(self, queue: cameraQueue)

        guard session.canAddOutput(cameraOutput) else {
            session.commitConfiguration()
            showCameraError()
            return
        }

        session.addOutput(cameraOutput)
        session.commitConfiguration()
        cameraIsReady = true
    }

    private func showPermissionError() {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = "Permita o acesso à câmera nos Ajustes para analisar componentes."
        }
    }

    private func showCameraError() {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = "Não foi possível iniciar a câmera traseira."
        }
    }

    // Inteligência artificial

    private func loadModel() {
        do {
            let blinkModel = try Blink(configuration: MLModelConfiguration())
            let visionModel = try VNCoreMLModel(for: blinkModel.model)

            classificationRequest = VNCoreMLRequest(model: visionModel) {
                [weak self] request, _ in
                self?.readResult(request: request)
            }

            classificationRequest?.imageCropAndScaleOption = .centerCrop
        } catch {
            errorMessage = "O modelo Blink.mlmodel não pôde ser carregado."
        }
    }

    private func readResult(request: VNRequest) {
        guard
            let results = request.results as? [VNClassificationObservation],
            let bestResult = results.first
        else {
            return
        }

        process(observation: bestResult)
    }

    private func process(observation: VNClassificationObservation) {
        let name = observation.identifier
        let confidence = observation.confidence

        guard name != "Undefect", confidence >= 0.70 else {
            clearDetection()
            return
        }

        let component = findComponent(identifier: name)
        let percentage = Int((confidence * 100).rounded())

        DispatchQueue.main.async { [weak self] in
            self?.currentDetection = DetectedComponent(
                component: component,
                confidence: percentage
            )
            self?.statusMessage = "Reconheci: \(component.name)"
            self?.errorMessage = nil
        }
    }

    private func findComponent(identifier: String) -> ElectronicComponent {
        let component = components.first {
            $0.id.lowercased() == identifier.lowercased()
        }

        return component ?? ElectronicComponent(
            id: identifier,
            name: identifier,
            detail: "Reconhecido pelo modelo Core ML",
            photoURL: nil,
            icon: "cpu"
        )
    }

    private func clearDetection() {
        DispatchQueue.main.async { [weak self] in
            self?.currentDetection = nil
            self?.statusMessage = "Nenhum componente reconhecido"
        }
    }
}

// Esta função é chamada automaticamente pela câmera para cada imagem capturada.
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard
            let image = CMSampleBufferGetImageBuffer(sampleBuffer),
            let classificationRequest
        else {
            return
        }

        let imageHandler = VNImageRequestHandler(
            cvPixelBuffer: image,
            orientation: .right
        )

        try? imageHandler.perform([classificationRequest])
    }
}
