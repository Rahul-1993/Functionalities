//
//  Constants.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 1/19/25.
//

import Foundation

let apiKey = "d13f9c37068dc04df45dc55c2d5e17ff"
let units = "metric"
let baseUrl = "https://api.openweathermap.org/data"
let version = "/2.5"
let endPoint = "/weather"

let storiesUrlString = "https://hws.dev/news-3.json"

let quizBaseUrl = "https://opentdb.com/api.php?"

///Mark:- Market Stack
let marketApiKey = "cd6302c8a6229f4777c3576eeecb5db0"
let marketBaseUrl = "http://api.marketstack.com/v2"
let marketTickerEndPoint = "/tickerslist"
let marketEodEndPoint = "/eod"

///Mark:- Cars Endpoint

let carBaseUrl = "https://carapi.app/api/"
let carAuth = "auth/login"


///Mark:- Product
let productUrl = "https://api.escuelajs.co/api/v1/products"

extension String {
    func decodedHTMLEntities() -> String {
        return self.replacingOccurrences(of: "&quot;", with: "'")
    }
}
