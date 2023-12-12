import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognition extends StatefulWidget {
  const SpeechRecognition({Key? key}) : super(key: key);

  @override
  State<SpeechRecognition> createState() => _SpeechRecognitionState();
}

class _SpeechRecognitionState extends State<SpeechRecognition> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {
      _lastWords = "";
    });
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    // If listening is active show the recognized words
                    // _speechToText.isListening
                    //     ? '$_lastWords'
                    //     // If listening isn't active but could be tell the user
                    //     // how to start it, otherwise indicate that speech
                    //     // recognition is not yet ready or not supported on
                    //     // the target device
                    //     :
                    _speechEnabled
                        ? 'Tap the microphone icon to start/stop recording...\nYou can say word "Search" and then last 4 digits of VT No.'
                        : 'Speech not available',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (_lastWords != "") SizedBox(height: 20),
                if (_lastWords != "")
                  Text(
                    'Recognized words',
                    style: TextStyle(fontSize: 20.0),
                  ),

                // Container(
                //   padding: EdgeInsets.all(16),
                //   child: Text(
                //     'Recognized words:',
                //     style: TextStyle(fontSize: 20.0),
                //   ),
                // ),

                if (_lastWords != "") SizedBox(height: 20),
                if (_lastWords != "")
                  Text(
                    // If listening is active show the recognized words
                    //  _speechToText.isListening
                    //  ?
                    '$_lastWords',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF11249F),
                    ),
                    // If listening isn't active but could be tell the user
                    // how to start it, otherwise indicate that speech
                    // recognition is not yet ready or not supported on
                    // the target device
                    // : _speechEnabled
                    //     ? 'Tap the microphone to start recording...'
                    //     : 'Speech not available',
                  ),
                if (_lastWords != "") SizedBox(height: 20),
                if (_lastWords != "" && _speechToText.isNotListening )
                  ElevatedButton(
                    child: const Text('Process'),
                    onPressed: () => Navigator.of(context)
                        .pop(_lastWords), //Navigator.pop(context),
                  ),
              ],
            ),
          ),
       
       GestureDetector(
        onTap: (){
          Navigator.of(context).pop('');
        },
         child: Padding(
           padding: const EdgeInsets.only(top:24.0 , right: 24.0),
           child: Align(
            alignment: Alignment.topRight,
             child: Icon( Icons.close,
             color: Colors.black,),
           ),
         ),
       )
       
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF11249F),
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Record',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
