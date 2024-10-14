import 'package:car_info/domain/entities/car.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@injectable
class GptService {
  late OpenAI openAI;

  GptService() {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    openAI = OpenAI.instance.build(
        token: apiKey!,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)));
  }

  Future<List<Car>> fetchCarsDataFromGpt(String query) async {
    try {
      final request = ChatCompleteText(
        model: Gpt4O2024ChatModel(),
        messages: [
          {
            'role': 'user',
            'content':
                'Provide car specifications for cars that match "$query" in JSON format'
          }
        ],
        maxToken: 200,
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

  // 응답 데이터를 Freezed Car 엔티티 리스트로 변환
  List<Car> _parseCarsData(String rawData) {
    final List<dynamic> carsJson = rawData
        .split('\n')
        .where((line) => line.isNotEmpty)
        .map((line) => line.trim())
        .toList();
    return carsJson.map((json) => Car.fromJson(json)).toList();
  }
}
