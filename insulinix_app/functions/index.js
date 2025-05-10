const functions = require("firebase-functions");
const axios = require("axios");

const GEMINI_API_KEY = "YAIzaSyDVHu4up-HfooaGc9rHH_BYx3kdKKUJ_1w";
const GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

exports.geminiChat = functions.https.onCall(async (data, context) => {
  const prompt = data.prompt;

  try {
    const res = await axios.post(`${GEMINI_URL}?key=${GEMINI_API_KEY}`, {
      contents: [
        {
          role: "user",
          parts: [{ text: prompt }]
        }
      ]
    });

    // No optional chaining to avoid lint/parser errors
    let reply = "No response";
    if (
      res.data &&
      res.data.candidates &&
      res.data.candidates[0] &&
      res.data.candidates[0].content &&
      res.data.candidates[0].content.parts &&
      res.data.candidates[0].content.parts[0] &&
      res.data.candidates[0].content.parts[0].text
    ) {
      reply = res.data.candidates[0].content.parts[0].text;
    }

    return { reply };
  } catch (err) {
    console.error("Gemini error:", err.response ? err.response.data : err.message);
    throw new functions.https.HttpsError("internal", "Failed to connect to Gemini API.");
  }
});
