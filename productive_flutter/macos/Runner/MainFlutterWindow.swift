import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // Enable better trackpad and mouse wheel scroll events
    if let scrollView = flutterViewController.view.subviews.first as? NSScrollView {
      scrollView.hasVerticalScroller = true
      scrollView.hasHorizontalScroller = true
      scrollView.autohidesScrollers = true
      
      // Enable touch bar scrolling and mouse wheel
      scrollView.scrollerStyle = .overlay
      
      // Enable smooth scrolling
      scrollView.scrollsDynamically = true
      
      // Make sure to handle both trackpad and mouse wheel
      scrollView.usesPredominantAxisScrolling = false
      
      // Set line and page scroll amounts for better mouse wheel experience
      scrollView.verticalLineScroll = 20
      scrollView.verticalPageScroll = 20
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
