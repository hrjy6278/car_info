import 'dart:convert';

import 'package:car_info/domain/entities/car.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@injectable
class GptService {
  final prompt = dotenv.env['PROMPT'];
  late OpenAI openAI;

  GptService() {
    openAI = OpenAI.instance.build(
      token: dotenv.env['OPENAI_API_KEY'],
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 60)),
      enableLog: true,
    );
  }

  Future<List<Car>> fetchCarsDataFromGpt(String query) async {
    try {
      final request = ChatCompleteText(
        model: Gpt4oMini2024ChatModel(),
        messages: [
          {
            'role': 'user',
            'content': '$prompt, keyword is $query',
          }
        ],
        maxToken: 4096,
        temperature: 0,
      );

      final response = await openAI.onChatCompletion(request: request);

      if (response != null && response.choices.isNotEmpty) {
        final message = response.choices.first.message;
        if (message == null) return [];

        return _parseCarsData(message.content);
      } else {
        throw Exception('Failed to fetch data from GPT');
      }
    } catch (e) {
      print('Error fetching data from GPT: $e');
      rethrow;
    }
  }

  List<Car> _parseCarsData(String rawData) {
    // GPT에서 올 수 있는 비 JSON 텍스트 제거 (예: ```json)
    final cleanedData = rawData.replaceAll(RegExp(r'```json|```'), '').trim();

    // JSON 파싱
    final dynamic jsonData = jsonDecode(cleanedData);

    if (jsonData is List) {
      return jsonData
          .map((carJson) => Car.fromJson(carJson as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }
}
