//
//  Environment.swift
//  DependencyPlugin
//
//  Created by 송영모 on 2023/04/27.
//

import Foundation
import ProjectDescription

public extension Project {
    enum Environment {
        public static let appName = "Pumping"
        public static let deploymentTarget = DeploymentTargets.iOS("16.0")
        public static let bundlePrefix = "com.depromeet.pumping"
        
        public static let watchDeploymentTarget = DeploymentTargets.watchOS("9.0")
    }
}
