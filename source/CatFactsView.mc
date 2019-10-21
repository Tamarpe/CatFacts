using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Graphics;

class CatFactsView extends WatchUi.View {

  var baseURL = "https://catfact.ninja/fact?limit=1&max_length=60";
  var catBackground, catFact, error;

  // Constructor
  function initialize() {
    View.initialize();
    catBackground = WatchUi.loadResource(Rez.Drawables.cat);
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() {
    getCatFact();
  }
    
  // Make an API call to get a random cat fact
  function getCatFact() {
    Communications.makeWebRequest(baseURL, null, {"Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED}, method(:receiveFact));
  }

  // Receive the data from the API
  function receiveFact(responseCode, data) {
    if (responseCode == 200) {
      catFact = data["fact"];
    }
    else {
      error = "An error occurred";
    }
    WatchUi.requestUpdate();
  }

  // Update the view
  function onUpdate(dc) {
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    dc.clear();
    dc.drawBitmap(0, 0, catBackground);
    if (catFact != null) {
      var text = new WatchUi.TextArea({
        :text=> catFact,
        :color=> Graphics.COLOR_WHITE,
        :backgroundColor => Graphics.COLOR_BLACK,
        :font=> Graphics.FONT_SMALL,
        :locX => WatchUi.LAYOUT_HALIGN_CENTER,
        :locY=> WatchUi.LAYOUT_VALIGN_CENTER,
        :width=> 160,
        :height=> 160
      });
      text.draw(dc);
    }
    else if (error != null) {
      dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, error, Graphics.TEXT_JUSTIFY_CENTER);
    }
    else {
      dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, "Loading ...", Graphics.TEXT_JUSTIFY_CENTER);
    }
  }

}
