//
//  EnvironmentExtension.swift
//  TemplateReto451
//
//  Created by José Molina on 02/09/25.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var authenticationController =  AuthenticationController(httpClient: HTTPClient())
    
}
