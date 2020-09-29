//
//  NewWidget.swift
//  NewWidget
//
//  Created by admin on 2020/9/29.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    public typealias Entry = SimpleEntry
  
    func placeholder(in context: Context) -> SimpleEntry {
      let widgetData = WidgetDataLoader.getWidgetData()
      return SimpleEntry(date: Date(), data: widgetData)
    }
    
    // 快照预览为了在小部件库中显示小部件
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
      let widgetData = WidgetDataLoader.getWidgetData()
      let entry = SimpleEntry(date: Date(),data: widgetData)
      completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
      
      // 这里面写网络请求返回  我这里demo用的plist数据
      let currentDate = Date()
      // 多久刷新一次
      let refreshDate = Calendar.current.date(byAdding: .second, value: 100, to: currentDate)!
      
      let widgetData = WidgetDataLoader.getWidgetData()
      let entry = SimpleEntry(date: Date(),data: widgetData)
      let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
      completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: WidgetData
}

struct NewWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
      WidgetEntryView(entry: entry)
    }
}

struct WidgetEntryView : View {
  var entry        : Provider.Entry
  var url1         :String = "alipayqr://platformapi/startapp?saId=10000007"
  
  var body: some View {
    VStack() {
        Spacer()
          .frame(height: RatioLen(15))
        // link 跳转app传参
      Link(destination: URL(string: url1)!) {
          HStack() {
            Spacer()
              .frame(width: RatioLen(15))
            // titile
            Text(entry.data.allTitie)
              .fontWeight(.regular)
              .font(.system(size: RatioLen(14)))
              .foregroundColor(Color.black)
            Spacer()
          }
        }
        Spacer()
          .frame(height: RatioLen(28))

        HStack() {
          Spacer()
            .frame(width: RatioLen(15))
          
          VStack(alignment: .leading) {
            Text(entry.data.desc)
              .fontWeight(.regular)
              .font(.system(size: RatioLen(14)))
              .foregroundColor(Color.blue)
              .multilineTextAlignment(.leading)
            Spacer()
            HStack {
              
              Text(entry.data.count)
                .fontWeight(.regular)
                .font(.system(size: RatioLen(13)))
                .foregroundColor(Color.red)
              Spacer()
            }.frame(height: RatioLen(18.5))
          }.frame(width: RatioLen(182.5))
          
          Spacer()
            .frame(width: RatioLen(15))
          Image(uiImage: entry.data.image)
            .resizable()
            .frame(width: RatioLen(101.5), height: RatioLen(68))
            .background(Color.yellow)
            .cornerRadius(5)
          Spacer()
            .frame(width: RatioLen(15))
        }.frame(height: RatioLen(68))
        Spacer()
    }
  }
}


@main
struct NewWidget: Widget {
    let kind: String = "NewWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NewWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct NewWidget_Previews: PreviewProvider {
    static var previews: some View {
      let widgetData = WidgetDataLoader.getWidgetData()
        NewWidgetEntryView(entry: SimpleEntry(date: Date(), data: widgetData))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
