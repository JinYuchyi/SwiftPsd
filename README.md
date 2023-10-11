# SwiftPsd
Swift wrapper for Photoshop and PSD api.

It use psd-tools - a python tool for parsing PSD files. So for data reading, Photoshop application is not necessary installed.

For data writing, it use Photoshop extendscript (javascript), which relies on Photoshop application.

Please refer to the Test file for some of the usage.


## Dependencies
[psd_tools](https://github.com/psd-tools/psd-tools)

## Usage

Get PSD file's layers' data:

`PsdUtils.shared.getLayerData(psdFile: testPsd.path)`

Set text content for text layers (Photoshop needed):

` PsdUtils.shared.setTextContent(psdIndexContentDict: [
            "/Users/jin/Documents/TestData/Photoshop/test1.psd": [0: "newStr1", 2: "newStr1"],
            "/Users/jin/Documents/TestData/Photoshop/test2.psd": [0: "newStr2", 1: "newStr2", 2: "newStr2"]
        ])`
