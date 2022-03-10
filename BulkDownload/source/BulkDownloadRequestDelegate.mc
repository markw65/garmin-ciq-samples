//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Communications;
import Toybox.Lang;
import Toybox.WatchUi;

//! Helper class makes a web or image request with context data.
class BulkDownloadRequestDelegate {
    private var _callback as Method(code as Number) as Void;

    //! Constructor
    //! @param callback The method to invoke when the request completes.
    public function initialize(callback as Method(code as Number) as Void) {
        _callback = callback;
    }

    //! Make a web request using the given options.
    //! @param url The URL to load in the web view to begin authentication
    //! @param params Items to append to the URL as a GET request or set as
    //!  the body for a POST request
    //! @param options Additional web request options
    //! @option options :method The HTTP method of the request
    //! @option options :headers A Dictionary of HTTP headers to include in the request
    //! @option options :responseType The format of the response
    //! @option options :context A user-specific context object to pass to the response callback
    //! @option options :maxBandwidth The maximum bandwidth
    //! @option options :fileDownloadProgressCallback A callback method
    public function makeWebRequest(url as String, params as Dictionary?, options as {
            :method as HttpRequestMethod,
            :headers as Dictionary,
            :responseType as HttpResponseContentType,
            :context as Object?,
            :maxBandwidth as Number,
            :fileDownloadProgressCallback as Method(totalBytesTransferred as Number, fileSize as Number?) as Void
        }?) as Void {
        Communications.makeWebRequest(url, params, options, self.method(:onWebResponse));
    }

    //! Make an image request using the given options.
    //! @param url The URL of an image to request
    //! @param params Items to append to the URL
    //! @param options Additional image options
    //! @option options :palette The color palette to restrict the image dithering to
    //! @option options :maxWidth The maximum width an image should be scaled to
    //! @option options :maxHeight The maximum height an image should be scaled to
    //! @option options :dithering The type of dithering to use when processing the image
    public function makeImageRequest(url as String, params as Dictionary?, options as {
            :palette as Array<Number>,
            :maxWidth as Number,
            :maxHeight as Number,
            :dithering as Dithering
        }) as Void {
        Communications.makeImageRequest(url, params, options, self.method(:onImageResponse));
    }

    //! Handle completed web request
    //! @param code The server response code or BLE error
    //! @param data Dictionary of content from a successful request
    public function onWebResponse(code as Number, data as Dictionary?) as Void {
        _callback.invoke(code);
    }

    //! Handle completed image request
    //! @param code The server response code or BLE error
    //! @param data A bitmap from a successful request
    public function onImageResponse(code as Number, data as BitmapResource?) as Void {
        _callback.invoke(code);
    }
}
