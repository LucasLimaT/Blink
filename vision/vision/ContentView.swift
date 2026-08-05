import SwiftUI
import AVFoundation
import Vision
import Combine

// MARK: - Camera Manager
class CameraManager: NSObject, ObservableObject {
    @Published var componenteDetectado: String = "Aponte a câmera para um componente"
    @Published var confianca: Double = 0.0

    let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private var visionRequest: VNCoreMLRequest?

    override init() {
        super.init()
        verificarPermissaoCamera()
        configurarModelo()
    }

    // MARK: Permissão da câmera
    private func verificarPermissaoCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configurarSessao()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] concedido in
                if concedido {
                    DispatchQueue.main.async {
                        self?.configurarSessao()
                    }
                }
            }
        default:
            DispatchQueue.main.async {
                self.componenteDetectado = "Sem permissão de câmera"
            }
        }
    }

    // MARK: Configuração da sessão de câmera
    private func configurarSessao() {
        session.beginConfiguration()
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device) else {
            session.commitConfiguration()
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }

        session.commitConfiguration()
    }

    // MARK: Carregamento do modelo CoreML
    private func configurarModelo() {
        guard let model = try? VNCoreMLModel(for: blink(configuration: MLModelConfiguration()).model) else {
            print("Erro ao carregar o modelo 'blink'")
            return
        }

        visionRequest = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let melhorResultado = results.first else { return }

            DispatchQueue.main.async {
                self?.confianca = Double(melhorResultado.confidence)

                if melhorResultado.identifier == "Undefect" || melhorResultado.confidence < 0.7 {
                    self?.componenteDetectado = "Nenhum componente reconhecido"
                } else {
                    self?.componenteDetectado = self?.nomeAmigavel(melhorResultado.identifier) ?? melhorResultado.identifier
                }
            }
        }
        visionRequest?.imageCropAndScaleOption = .centerCrop
    }

    // MARK: Nomes amigáveis para exibir na tela
    private func nomeAmigavel(_ label: String) -> String {
        switch label {
        case "rfid": return "Módulo RFID"
        case "Esp": return "ESP32 / ESP8266"
        case "Protoboard": return "Protoboard"
        default: return label
        }
    }

    func iniciar() {
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }

    func parar() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
}

// MARK: - Processamento de cada frame da câmera
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let request = visionRequest else { return }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right)
        try? handler.perform([request])
    }
}

// MARK: - Preview da câmera (UIKit -> SwiftUI)
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewUIView {
        let view = PreviewUIView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewUIView, context: Context) {}
}

// UIView customizada para o preview acompanhar corretamente o tamanho da tela
class PreviewUIView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}

// MARK: - Tela principal
struct ContentView: View {
    @StateObject private var camera = CameraManager()

    var body: some View {
        ZStack(alignment: .bottom) {
            CameraPreview(session: camera.session)
                .ignoresSafeArea()

            VStack(spacing: 8) {
                Text(camera.componenteDetectado)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                if camera.confianca > 0 {
                    Text("Confiança: \(Int(camera.confianca * 100))%")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.6))
            .padding(.bottom, 40)
        }
        .onAppear {
            camera.iniciar()
        }
        .onDisappear {
            camera.parar()
        }
    }
}

#Preview {
    ContentView()
}
