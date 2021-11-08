//
//  AnyPrinterOperation.DynamicDispatch.swift
//  
//
//  Created by Connor Barnes on 10/19/21.
//

import SwiftUI

extension AnyPrinterOperation {
  public final class DynamicDispatch {
    public static let shared = DynamicDispatch()
    private init() { }
    
    private var _finalized = false
    fileprivate var _registered: Set<AnyPrinterOperation.Kind> = []
    fileprivate var _empty: [AnyPrinterOperation.Kind : Any] = [:]
    
    typealias _NameClosure = (Any) -> String
    typealias _ThumbnailNameClosure = (Any) -> String
    typealias _RunClosure = (Any, PrinterController) async throws -> Void
    typealias _BodyClosure = (Binding<Any>) -> AnyView
    typealias _EncodeClosure = (AnyPrinterOperation.Kind, Any, Bool, Bool, UUID, Encoder) throws -> Void
    typealias _DecodeClosure = (Decoder) throws -> AnyPrinterOperation
    
    private var _nameClosure: [AnyPrinterOperation.Kind : _NameClosure] = [:]
    private var _thumbnailNameClosure: [AnyPrinterOperation.Kind : _ThumbnailNameClosure] = [:]
    private var _runClosure: [AnyPrinterOperation.Kind : _RunClosure] = [:]
    private var _bodyClosure: [AnyPrinterOperation.Kind : _BodyClosure] = [:]
    private var _encodeClosure: [AnyPrinterOperation.Kind : _EncodeClosure] = [:]
    private var _decodeClosure: [AnyPrinterOperation.Kind : _DecodeClosure] = [:]
    
    func dispatchName(forKind kind: AnyPrinterOperation.Kind) -> _NameClosure {
      assert(_finalized, "Dynamic Loader trying to access name closure, but has not been finalized")
      return _nameClosure[kind]!
    }
    
    func dispatchThumbnailName(forKind kind: AnyPrinterOperation.Kind) -> _ThumbnailNameClosure {
      assert(_finalized, "Dynamic Loader trying to access name closure, but has not been finalized")
      return _thumbnailNameClosure[kind]!
    }
    
    func dispatchRun(forKind kind: AnyPrinterOperation.Kind) -> _RunClosure {
      assert(_finalized, "Dynamic Loader trying to access name closure, but has not been finalized")
      return _runClosure[kind]!
    }
    
    func dispatchBody(forKind kind: AnyPrinterOperation.Kind) -> _BodyClosure {
      assert(_finalized, "Dynamic Loader trying to access name closure, but has not been finalized")
      return _bodyClosure[kind]!
    }
    
    func dispatchEncode(forKind kind: AnyPrinterOperation.Kind) -> _EncodeClosure {
      assert(_finalized, "Dynamic Loader trying to access name closure, but has not been finalized")
      return _encodeClosure[kind]!
    }
    
    func dispatchDecode(forKind kind: AnyPrinterOperation.Kind) -> _DecodeClosure {
      assert(_finalized, "Dynamic Loader trying to access name closure, but has not been finalized")
      return _decodeClosure[kind]!
    }
    
    public func register<Configuration: Codable & Hashable, Body: View>(
      kind: AnyPrinterOperation.Kind,
      operation: PrinterOperation<Configuration, Body>
    ) -> DynamicDispatch {
      _nameClosure[kind] = { operation.name($0 as! Configuration) }
      _thumbnailNameClosure[kind] = { operation.thumbnailName($0 as! Configuration) }
      _runClosure[kind] = { try await operation.run($0 as! Configuration, $1) }
      _bodyClosure[kind] = { configuration in
        let binding = Binding {
          configuration.wrappedValue as! Configuration
        } set: { newValue in
          configuration.wrappedValue = newValue
        }
        
        return AnyView(operation.body(binding))
      }
			
			_encodeClosure[kind] = { kind, configuration, isEnabled, continueOnError, id, encoder in
				let storage = PrinterOperation<Configuration, Body>.Storage(
					kind: kind,
					configuration: configuration as! Configuration,
					isEnabled: isEnabled,
					continueOnError: continueOnError,
					id: id
				)
				try storage.encode(to: encoder)
			}
			
			_decodeClosure[kind] = { decoder in
				let storage = try PrinterOperation<Configuration, Body>.Storage(from: decoder)
				return AnyPrinterOperation(kind: storage.kind,
																	 configuration: storage.configuration,
																	 isEnabled: storage.isEnabled,
																	 continueOnError: storage.continueOnError,
																	 id: storage.id)
			}
      
      _empty[kind] = operation.configuration
      _registered.insert(kind)
      
      return self
    }
    
    public func finalize() {
      guard !_finalized else {
        fatalError("Trying to finalize Dynamic Loader that is already finalized. Dynamic Loaders may only be finalized once")
      }
      
      AnyPrinterOperation.Kind.allCases.forEach { kind in
        guard _registered.contains(kind) else {
          fatalError("Trying to finalize Dynamic Loader, but \(kind) has not been registered")
        }
      }
      
      _finalized = true
    }
  }
}

// MARK: Empty Operations
extension AnyPrinterOperation {
  public static var allEmptyOperations: [AnyPrinterOperation] {
    Kind.allCases.map { kind in
      AnyPrinterOperation(
        kind: kind,
        configuration: DynamicDispatch.shared._empty[kind]!,
        isEnabled: true,
        continueOnError: false,
        id: UUID()
      )
    }
  }
}
