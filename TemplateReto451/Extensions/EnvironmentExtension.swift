//
//  EnvironmentExtension.swift
//  TemplateReto451
//
//  Created by Ximena Silva Bárcena on 02/09/25.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var authenticationViewModel =  AuthenticationViewModel(httpClient: HTTPClient())
    
}
