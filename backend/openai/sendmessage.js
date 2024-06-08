require('dotenv').config();
const OpenAIApi = require('openai');

const openai = new OpenAIApi({
    api_key: 'process.env.OPENAI_API_KEY'
});

// const initial_message = 'Persona:\
// 당신의 이름은 maru이다.\
// maru는 일본어만 사용할 수 있다.\
// maru는 제일 처음에 사용자에게 자기소개를 부탁한다.\
// maru는 사용자와 친근하게 대화한다.\
// maru는 사용자와의 대화가 이어지도록 끊임없이 질문을 유도한다.\
// maru는 사용자와의 대화가 끝나면 사용자의 답변들을 모두 종합해 일본어 구사 능력을 평가한다.\
// ';

const initial_message = 'Persona:\
당신의 이름은 maru입니다.\
maru는 일본어만 사용할 수 있습니다.\
maru는 일단 먼저 자기소개를 부탁합니다.\
maru는 사용자에게 친근한 태도로 대합니다.\
maru는 항상 사용자가 답하기 쉬운 질문을 던져 대화가 지속되도록 합니다.\
maru는 대화가 종료된 후 사용자의 모든 답변을 종합하여 일본어 구사 능력을 평가합니다.\
다음 지시에 따라주세요:\
1. 대화를 시작할 때 자기소개를 하고 친근한 톤으로 사용자에게 인사합니다.\
2. 대화 중 항상 일본어를 사용하고, 정중하고 친근한 태도로 대합니다.\
3. 사용자가 답하기 쉬운 질문을 적절히 던져 대화가 끊기지 않도록 합니다.\
4. 사용자가 질문에 답하면 그 내용에 기반해 새로운 질문을 만들어 대화를 이어갑니다.\
5. 사용자가 문맥에 자연스러운 대답을 하고 있는지에 대한 Comprehensibility 점수를 100점으로 시작하여 감점 방식으로 평가합니다. 매번 질답에서 사용자가 문맥에 벗어나지 않고 자연스러운 답변을 하고 있는지 판단합니다. 만약 그렇지 않다면 점수가 차감됩니다. 이 때 자연스럽지 않은 정도를 판단하여 해당 정도가 크다면 많이 차감됩니다.\
6. 대화가 종료되면 text type (문장 길이 구성 능력) 점수와 Variability (표현의 다양성) 점수가 system message로 도착할 것입니다. 지금까지의 사용자의 답변을 종합하여 일본어 구사 능력을 평가하는 특별한 메시지를 보냅니다.\
7. 평가 메시지에는 사용자의 일본어 강점과 개선할 점을 구체적으로 기재합니다.\
8. 최종적으로 text type 점수와 Variability 점수, Comprehensibility 점수를 이용하여 사용자의 일본어 구사 능력을 평가합니다. 평가 등급은 하급, 중하급, 중급, 중상급, 상급으로 총 5개의 평가 등급 중에 하나를 사용자에게 부여합니다.\
'

const final_message = "text type 점수는 30점, Variability 점수는 20점이야. 지금까지의 대화에 대한 답변을 바탕으로 일본어 실력에 대해 평가해줘. 레벨은 초급, 초중급, 중급, 중삽급, 상급 중에 하나를 골라서 판단해줘"

async function callChatGPT_final(message) {

    //console.log(message)

    try {
        const response = await openai.chat.completions.create({
            model: 'gpt-3.5-turbo',
            messages: [
              { role: 'system', content: final_message },
              { role: 'user', content: message },
            ],
          });

        // 모델의 응답에서 답변 가져오기
        const answer = response.choices[0].message.content;
        //console.log('ChatGPT 답변:', answer);
    
        return answer;
    } catch (error) {
        console.error('ChatGPT 요청 중 오류:', error);
        throw error;
    }
}

async function callChatGPT_first(message) {

    //console.log(message)

    try {
        const response = await openai.chat.completions.create({
            model: 'gpt-3.5-turbo',
            messages: [
              { role: 'system', content: initial_message },
              { role: 'user', content: message },
            ],
          });

        // 모델의 응답에서 답변 가져오기
        const answer = response.choices[0].message.content;
        //console.log('ChatGPT 답변:', answer);
    
        return answer;
    } catch (error) {
        console.error('ChatGPT 요청 중 오류:', error);
        throw error;
    }
}


  
// ChatGPT에 대화식으로 요청을 보내는 함수
async function callChatGPT(message) {

    //console.log(message)

    try {
        const response = await openai.chat.completions.create({
            model: 'gpt-3.5-turbo',
            messages: [
              { role: 'system', content: "日本語で自由対話ロールプレイをしたい。まるで友達と会話するかのように答えてください。自然に" },
              { role: 'user', content: message },
            ],
          });

        // 모델의 응답에서 답변 가져오기
        const answer = response.choices[0].message.content;
        //console.log('ChatGPT 답변:', answer);
    
        return answer;
    } catch (error) {
        console.error('ChatGPT 요청 중 오류:', error);
        throw error;
    }
}

module.exports = { callChatGPT_first, callChatGPT_final, callChatGPT };