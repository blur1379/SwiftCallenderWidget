//
//  CalendarHeaderView.swift
//  SwiftCallenderWidget
//
//  Created by Mohammad Blur on 8/6/24.
//

import SwiftUI

struct CalendarHeaderView: View {
    let daysOfWeek = ["S","M","T","W","T","F","S"]
    var font: Font = .body
    var body: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(font)
                    .fontWeight(.black)
                    .foregroundStyle(.orange)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    CalendarHeaderView()
}
