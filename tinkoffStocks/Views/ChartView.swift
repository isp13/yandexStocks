//
//  ChartView.swift
//  Yandex Stocks
//
//  Created by Никита Казанцев on 28.03.2021.
//
// Вью с графиком, который строится по осям ОХ ОУ, где ОХ - порядковый номер соответствующего элемента, а ОУ - value этого значения


import SwiftUI

struct LineView: View {
    var data: [(Double)]
    var title: String?
    var price: String?

    public init(data: [Double],
                title: String? = nil,
                price: String? = nil) {
        
        self.data = data
        self.title = title
        self.price = price
    }
    
    public var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 8) {
                
                // верхний лейбл с текстом
                Group{
                    if (self.title != nil){
                        Text(self.title!)
                            .font(.title)
                    }
                    if (self.price != nil){
                        Text(self.price!)
                            .font(.body)
                        .offset(x: 5, y: 0)
                    }
                }.offset(x: 0, y: 0)
                
                // сам график линейный
                ZStack(alignment: .bottomTrailing){
                    GeometryReader{ reader in
                        Line(data: self.data,
                             frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width , height: reader.frame(in: .local).height))
                        )
                            .offset(x: 0, y: 0)
                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 200)
                    .offset(x: 0, y: -100)
                    
                    
                    // нижняя полоска оси ОХ
                    HStack {
                        
                        // левая часть, выводит дату начала отсчета
                        VStack(alignment: .leading) {
                            Rectangle()
                                .accentColor(Color(UIColor.lightGray))
                                .frame(width: 1, height: 2)
                                .opacity(0.7)
                            
                        Text(UTCtoClockTimeOnly(currentDate: Calendar.current.date(byAdding: .day, value: -365, to: Date())!, format: "MM.YYYY"))
                            .font(.caption)
                            .foregroundColor(Color(UIColor.lightGray))
                        }
                        
                        Spacer()
                        
                        // правая часть, выводит дату конца отсчета
                        VStack(alignment: .trailing) {
                            Rectangle()
                                .accentColor(Color(UIColor.lightGray))
                                .frame(width: 1, height: 2)
                                .opacity(0.5)
                            
                        Text(UTCtoClockTimeOnly(currentDate: Date(), format: "MM.YYYY"))
                            .font(.caption)
                            .foregroundColor(Color(UIColor.lightGray))
                        }
                    }.offset(x: 0, y: -80)

                }
                .frame(width: geometry.frame(in: .local).size.width, height: 200)
        
            }.background(Color.black)
        }
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        LineView(data: [8,23,54,32,12,37,7,23,43], title: "Full chart")
    }
}

struct Line: View {
    var data: [(Double)]
    @Binding var frame: CGRect

    let padding:CGFloat = 30
    
    var stepWidth: CGFloat {
        if data.count < 2 {
            return 0
        }
        return frame.size.width / CGFloat(data.count-1)
    }
    var stepHeight: CGFloat {
        var min: Double?
        var max: Double?
        let points = self.data
        if let minPoint = points.min(), let maxPoint = points.max(), minPoint != maxPoint {
            min = minPoint
            max = maxPoint
        }else {
            return 0
        }
        if let min = min, let max = max, min != max {
            if (min <= 0){
                return (frame.size.height-padding) / CGFloat(max - min)
            }else{
                return (frame.size.height-padding) / CGFloat(max + min)
            }
        }
        
        return 0
    }
    var path: Path {
        let points = self.data
        return Path.lineChart(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
    }
    
    public var body: some View {
        
        ZStack {
            self.path
                .stroke(data.first! < data.last! ? Color.green: Color.red ,style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))
                .rotationEffect(.degrees(180), anchor: .center)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .drawingGroup()
        }
    }
}

extension Path {
    
    static func lineChart(points:[Double], step:CGPoint) -> Path {
        var path = Path()
        if (points.count < 2){
            return path
        }
        guard let offset = points.min() else { return path }
        let p1 = CGPoint(x: 0, y: CGFloat(points[0]-offset)*step.y)
        path.move(to: p1)
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: step.x * CGFloat(pointIndex), y: step.y*CGFloat(points[pointIndex]-offset))
            path.addLine(to: p2)
        }
        return path
    }
}
