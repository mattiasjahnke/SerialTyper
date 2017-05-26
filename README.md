# SerialTyper

SerialTyper is a simple utility tool that lives in your menu bar and sends keyboard events (ascii keycodes) to a serial port that the app is connected to.

## Carthage
SerialTyper uses [Carthage](https://github.com/Carthage/Carthage) to manage dependencies.

Run `carthage update` to download and compile the required frameworks.

## Usage
Select a port and a baud rate - SerialTyper will automatically try to connect to the port.
![image](https://cloud.githubusercontent.com/assets/2101850/26487976/f185e300-4201-11e7-8f8d-2f23132ae0a9.png)

## Todo
- Improve Error handling
- Add more configuration
- Automatically connect when a port becomes available

## Thanks to
[@evalir.io](http://instagram.com/evalir.io) for the app icon and menu logo

![logo](https://github.com/mattiasjahnke/SerialTyper/blob/master/SerialTyper/Assets.xcassets/AppIcon.appiconset/Icon-App-128x128@2x.png?raw=true)

## License
 
The MIT License (MIT)

Copyright (c) 2017 Mattias Jähnke

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
