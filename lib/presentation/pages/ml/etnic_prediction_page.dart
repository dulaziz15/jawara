import 'dart:convert';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

@RoutePage()
class EtnicPredictionPage extends StatefulWidget {
  const EtnicPredictionPage({Key? key}) : super(key: key);

  @override
  State<EtnicPredictionPage> createState() => _EtnicPredictionPageState();
}

class _EtnicPredictionPageState extends State<EtnicPredictionPage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? imageBytes;
  bool loading = false;
  Map<String, dynamic>? result;

  Future<void> pickFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      Uint8List fileBytes = await photo.readAsBytes();
      setState(() {
        imageBytes = fileBytes;
        result = null;
      });
    }
  }

  Future<void> upload() async {
    if (imageBytes == null) return;

    setState(() => loading = true);

    final uri =
        Uri.parse("https://dulaziz15.pythonanywhere.com/api/mobile/predict");

    var request = http.MultipartRequest("POST", uri)
      ..files.add(http.MultipartFile.fromBytes(
        "file",
        imageBytes!,
        filename: "upload.jpg",
      ));

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final decoded = jsonDecode(respStr);

      await Future.delayed(Duration(milliseconds: 800));

      setState(() {
        loading = false;
        result = decoded["analysis"];
      });
    } catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 22),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upload Failed",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      e.toString(),
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 18),
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              ),
            ],
          ),
          backgroundColor: Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prediction = result?["prediction"];
    final probabilities = result?["probabilities"];
    final bool hasImage = imageBytes != null;

    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // APP BAR SECTION
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            expandedHeight: 180,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1A237E),
                      Color(0xFF283593),
                      Color(0xFF3949AB),
                    ],
                    stops: [0.0, 0.6, 1.0],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 24, right: 24, top: 50, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Ethnicity\n",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                            TextSpan(
                              text: "AI Predictor",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w200,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Advanced facial recognition for ethnicity detection",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: Icon(Icons.info_outline, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Color(0xFF1E1E2D),
                        title: Text("How to Use",
                            style: TextStyle(color: Colors.white)),
                        content: Text(
                          "1. Capture a clear facial photo\n"
                          "2. Upload for AI analysis\n"
                          "3. View detailed ethnicity predictions",
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK",
                                style: TextStyle(color: Color(0xFF00BCD4))),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // MAIN CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // IMAGE UPLOAD SECTION
                  Container(
                    height: hasImage ? 320 : 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF1E1E2D),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: Color(0xFF2D2D3D),
                        width: 1.5,
                      ),
                    ),
                    child: hasImage
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.memory(
                                  imageBytes!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.2),
                                      Colors.black.withOpacity(0.4),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.check_circle,
                                          color: Colors.green, size: 14),
                                      SizedBox(width: 6),
                                      Text(
                                        "Image Ready",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 16,
                                right: 16,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.white.withOpacity(0.1),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: BorderSide(
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      icon: Icon(Icons.refresh, size: 16),
                                      label: Text("Retake"),
                                      onPressed: pickFromCamera,
                                    ),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF00BCD4),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      icon: loading
                                          ? SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            )
                                          : Icon(Icons.bolt, size: 16),
                                      label: loading
                                          ? Text("Analyzing...")
                                          : Text("Analyze Now"),
                                      onPressed:
                                          loading || !hasImage ? null : upload,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF3949AB),
                                      Color(0xFF00BCD4),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.photo_camera_outlined,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "No Image Selected",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                child: Text(
                                  "Take a clear facial photo to begin analysis",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.6),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF3949AB),
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(180, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                icon: Icon(Icons.camera_alt_outlined, size: 20),
                                label: Text(
                                  "Capture Photo",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: pickFromCamera,
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: 30),

                  // PREDICTION RESULTS SECTION
                  if (result != null)
                    _buildResultSection(prediction, probabilities),

                  // HOW IT WORKS SECTION (hanya ditampilkan jika belum ada gambar atau hasil)
                  if (!hasImage || result == null)
                    _buildHowItWorksSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How It Works",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Simple steps to get predictions",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepCard(
                icon: Icons.camera_alt,
                title: "Capture",
                subtitle: "Take photo",
                color: Color(0xFF3949AB),
              ),
              SizedBox(width: 12),
              _buildStepCard(
                icon: Icons.cloud_upload,
                title: "Upload",
                subtitle: "Send to AI",
                color: Color(0xFF00BCD4),
              ),
              SizedBox(width: 12),
              _buildStepCard(
                icon: Icons.analytics,
                title: "Results",
                subtitle: "Get analysis",
                color: Color(0xFF4CAF50),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        height: 100,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Color(0xFF1E1E2D),
          border: Border.all(
            color: Color(0xFF2D2D3D),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection(
      Map<String, dynamic>? prediction, Map<String, dynamic>? probabilities) {
    final confidence = prediction?["confidence"]?.toDouble() ?? 0.0;
    final ethnicity = prediction?["ethnicity"] ?? "Unknown";
    final level = prediction?["level"] ?? "Unknown";

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF3949AB).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFF3949AB).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.analytics_outlined,
                    color: Color(0xFF00BCD4), size: 18),
                SizedBox(width: 8),
                Text(
                  "Prediction Results",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00BCD4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Color(0xFF1E1E2D),
              border: Border.all(
                color: Color(0xFF2D2D3D),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                // MAIN PREDICTION
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF3949AB),
                            Color(0xFF00BCD4),
                          ],
                        ),
                      ),
                      child: Icon(Icons.emoji_people,
                          color: Colors.white, size: 24),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Predicted Ethnicity",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            ethnicity,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Confidence: ${confidence.toStringAsFixed(1)}% • Level: $level",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // CONFIDENCE INDICATOR
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Confidence Level",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${confidence.toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _getConfidenceColor(confidence),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: confidence / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: _getConfidenceGradient(confidence),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("0%", style: TextStyle(
                          fontSize: 11,
                          color: Colors.white54,
                        )),
                        Text("50%", style: TextStyle(
                          fontSize: 11,
                          color: Colors.white54,
                        )),
                        Text("100%", style: TextStyle(
                          fontSize: 11,
                          color: Colors.white54,
                        )),
                      ],
                    ),
                  ],
                ),

                if (probabilities != null && probabilities.isNotEmpty) ...[
                  SizedBox(height: 24),
                  Text(
                    "Detailed Probabilities",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  ..._buildProbabilityItems(probabilities),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildProbabilityItems(Map<String, dynamic> probabilities) {
    final items = [
      {
        "label": "African",
        "value": probabilities["Africa"] ?? 0.0,
        "color": Color(0xFF2196F3),
        "icon": Icons.public
      },
      {
        "label": "Asian",
        "value": probabilities["Asian"] ?? 0.0,
        "color": Color(0xFF4CAF50),
        "icon": Icons.flag
      },
      {
        "label": "European",
        "value": probabilities["Eropa"] ?? 0.0,
        "color": Color(0xFF9C27B0),
        "icon": Icons.location_city
      },
    ];

    return items.map((item) {
      final value = (item["value"] as num).toDouble();
      return Container(
        margin: EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: item["color"].withOpacity(0.2),
              ),
              child: Icon(item["icon"], color: item["color"], size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item["label"],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${value.toStringAsFixed(1)}%",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: value / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: item["color"],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 80) return Color(0xFF4CAF50);
    if (confidence >= 60) return Color(0xFF2196F3);
    if (confidence >= 40) return Color(0xFFFF9800);
    return Color(0xFFF44336);
  }

  List<Color> _getConfidenceGradient(double confidence) {
    if (confidence >= 80) return [Color(0xFF4CAF50), Color(0xFF8BC34A)];
    if (confidence >= 60) return [Color(0xFF2196F3), Color(0xFF03A9F4)];
    if (confidence >= 40) return [Color(0xFFFF9800), Color(0xFFFFC107)];
    return [Color(0xFFF44336), Color(0xFFE57373)];
  }
}