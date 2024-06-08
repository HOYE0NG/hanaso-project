const express = require('express');
const router = express.Router();
const Favorite = require('../models/Favorite');
const { isLoggedIn } = require('../utils/middlewares');
const { callChatGPT, callChatGPT_final } = require('../openai/sendmessage');
const { callChatGPT_first } = require('../openai/sendmessage');

router.post('/', async (req, res) => {
    console.log("chat post recieve")
    const message = req.body.message;
    const messageCount = req.body.messageCount;

    console.log(messageCount)

    try {

        if (messageCount==0){
            const chatResponse = await callChatGPT_first(message);
            // ChatGPT의 응답을 클라이언트에 반환
            res.json({ response: chatResponse });
        } else if(messageCount==3) {
            const chatResponse = await callChatGPT_final(message);
            // ChatGPT의 응답을 클라이언트에 반환
            res.json({ response: chatResponse });
        }
        else{
            const chatResponse = await callChatGPT(message);
            // ChatGPT의 응답을 클라이언트에 반환
            res.json({ response: chatResponse });
        }
        

        
    } catch (error) {
        console.error('대화 중 오류 발생:', error);
        res.status(500).json({ error: '대화 중 오류 발생' });
    }
});

module.exports = router;