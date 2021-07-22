import XCTest
@testable import PrinterController

final class PrinterControllerTests: XCTestCase {
  let waveformConfiguration = WaveformConfiguration(address: "192.168.1.3", port: 5025)
  let xpsq8Configuration = XPSQ8Configuration(address: "192.168.1.4", port: 5001)
  
  func testWaveformConnection() async {
    let controller = await PrinterController()
    
    do {
      try await controller.connectToWaveform(configuration: waveformConfiguration)
    } catch {
      XCTFail("Could not connect to waveform generator.")
    }
    
    await controller.disconnectFromWaveform()
    
    do {
      try await controller.connectToWaveform(configuration: waveformConfiguration)
    } catch {
      XCTFail("Could not reconnect to waveform generator.")
    }
  }
  
  func testXPSQ8Connection() async {
    let controller = await PrinterController()
    
    do {
      try await controller.connectToXPSQ8(configuration: xpsq8Configuration)
    } catch {
      XCTFail("Could not connect to XPS-Q8.")
    }
    
    await controller.disconnectFromXPSQ8()
    
    do {
      try await controller.connectToXPSQ8(configuration: xpsq8Configuration)
    } catch {
      XCTFail("Could not reconnect to XPS-Q8.")
    }
  }
}

// MARK: - Unsafe Wait For
func unsafeWaitFor(_ operation: @escaping () async -> ()) {
  let semaphore = DispatchSemaphore(value: 0)
  Task {
    await operation()
    semaphore.signal()
  }
  semaphore.wait()
}
