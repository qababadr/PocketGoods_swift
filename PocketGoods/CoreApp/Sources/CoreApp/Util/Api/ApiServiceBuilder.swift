//
//  ApiServiceBuilder.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//
import Foundation

public class ApiServiceBuilder {
    private var baseUrl: String = ""
    private var timeout: Double = 0
    private var _withLogger: Bool = false
    private var _session: URLSession = URLSession.shared
    private var _background: Bool = false

    public init() {}

    public func baseUrl(stringUrl: String) -> ApiServiceBuilder {
        baseUrl = stringUrl
        return self
    }

    public func timeout(timeout: Double = 30) -> ApiServiceBuilder {
        self.timeout = timeout
        return self
    }

    public func withLogger() -> ApiServiceBuilder {
        _withLogger = true
        return self
    }

    public func session(session: URLSession) -> ApiServiceBuilder {
        _session = session
        return self
    }

    public func withBackgroundTask() -> ApiServiceBuilder {
        _background = true
        return self
    }

    public func build() -> ApiService {
        return ApiService(
            session: _session,
            withBackground: _background,
            timeout: timeout,
            baseUrl: baseUrl,
            withLogger: _withLogger
        )
    }
}
