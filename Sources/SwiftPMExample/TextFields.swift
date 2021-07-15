//
//  TextFields.swift
//  
//
//  Created by Inpyo Hong on 2021/07/15.
//

import Foundation
import SwiftUI
import Combine

extension SwiftPMExample {
    public struct TextFields {
        public init() { }
    }
}

extension SwiftPMExample.TextFields {
    public struct MobileNo :View {
        @Binding var text: String
        let placeholder: String
        
        /*
         휴대폰 번호 유효성에 따른 테두리 스타일링을 위한 Flag
        */
        @State private var isValid: Bool = false
        
        public init(text: Binding<String>, placeholder: String = "") {
            self._text = text
            self.placeholder = placeholder
        }
        
        public var body: some View {
            TextField(placeholder, text: $text)
                .textContentType(.telephoneNumber)
                .keyboardType(.numberPad)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8.0)
                        .stroke()
                        /*
                     휴대폰 번호가 유효하면 Blue, 아니면 Red 색이 가진
                     RoundedRectangle로 테두리를 만들어준다.
                        */
                    .foregroundColor(self.isValid ? .blue : .red)
                )
                .onReceive(Just(self.text)) { _ in
//                    self.formatMobileNo()
                }
        }
        
        /// 텍스트 포맷팅 및 유효성 확인
        private func formatMobileNo() {
            /*
             입력 중 첫 하이픈 추가
             */
            if self.text.count == 4 && !self.text.contains("-") {
                self.text.insert("-", at: self.text.index(self.text.startIndex, offsetBy: 3))
            }
            /*
             입력 중 두번째 하이픈 추가
             */
            if self.text.count == 9 && self.text[self.text.index(self.text.startIndex, offsetBy: 8)] != "-" {
                self.text.insert("-", at: self.text.index(self.text.startIndex, offsetBy: 8))
            }
            
            /*
            삭제 중 하이픈 삭제
            글자 수 초과 시 마지막 글자 삭제
            */
            if (self.text.count == 9 && self.text.last == "-")
                || (self.text.count == 4 && self.text.last == "-")
                || (self.text.count > 13) {
                self.text.removeLast()
            }
            
            /*
            유효성 Flag 확인
            */
            self.isValid = self.text.count == 13
        }
    }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      SwiftPMExample.TextFields.MobileNo(text: .constant("Hello World"), placeholder: "Placeholder")
          .padding()
  }
}
