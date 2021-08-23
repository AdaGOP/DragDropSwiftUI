//
//  ContentView.swift
//  BelajarDragDropSwiftUI
//
//  Created by zein rezky chandra on 16/08/21.
//

import SwiftUI
import WebKit

struct ContentItem: Identifiable {
    let id = UUID()
    let link: URL
}

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let webView: WKWebView
    var urlString = ""
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}

struct ContentView: View {

    @State var content_selection: Set<UUID> = []
    
    @StateObject var viewModel = WebViewModel()
    
    @State private var items: [ContentItem] = [
        ContentItem(link: URL(string: "https://facebook.com")!),
        ContentItem(link: URL(string: "https://google.com")!),
        ContentItem(link: URL(string: "https://linkedin.com")!)
    ]

    var body: some View {
        VStack {
            NavigationView {
                List(selection: $content_selection, content: {
                    ForEach(items) { item in
                        NavigationLink(
                            destination: WebView(webView: viewModel.webView),
                            label: {
                                Text(item.link.absoluteString)
                            })
                            .onDrag({ NSItemProvider(object: item.link as NSURL) })
                            .onDisappear(perform: {
                                viewModel.loadURLFrom(url: item.link.absoluteString)
                            })
                    }
                    .onInsert(of: ["public.url"], perform: dropOnPerformed)
                })
                .navigationBarTitle(Text("CONTENT LIST"), displayMode: .automatic)
                .navigationBarHidden(false)
                .background(NavigationConfigurator { nc in
                                nc.navigationBar.barTintColor = .blue
                                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
                            })
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func dropOnPerformed(at index: Int, _ items: [NSItemProvider]) {
        for item in items {
            _ = item.loadObject(ofClass: URL.self, completionHandler: { url, _ in
                if let url = url {
                    DispatchQueue.main.async {
                        self.items.insert(ContentItem(link: url), at: 0)
                    }
                }
            })
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
