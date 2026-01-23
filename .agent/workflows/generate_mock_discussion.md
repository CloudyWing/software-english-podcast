---
description: Generate a 30-60 second mock discussion (dialogue) between Phoebe and HsiaoChen based on the keywords of a podcast episode.
---

# Generate Mock Discussion Skill

This skill generates a short, natural, and cheerful "mock discussion" to be appended to the end of a podcast transcript (before the outro). The goal is to demonstrate how to use the episode's keywords in a realistic conversation, such as a stand-up meeting, a code review, or a system design discussion.

## 1. Input Analysis
- **Context**: Read the current episode's XML file to understand the topic and the list of keywords defined.
- **Characters**:
  - **Phoebe (en-US-PhoebeMultilingualNeural)**: The technical expert. She speaks mostly English but can understand Chinese context. In this mock discussion, she should speak **Natural English** (complex sentences, idioms, professional tone but friendly).
  - **HsiaoChen (zh-TW-HsiaoChenNeural)**: The host/developer. She speaks Traditional Chinese (Taiwan). In the mock discussion, she acts as a colleague asking questions or clarifying details.

## 2. Content Generation Rules
- **Duration**: Target roughly 30-60 seconds of dialogue.
- **Format**:
  - Use `mstts:express-as style="cheerful"` for the entire discussion block since it's a chat.
  - Use `prosody rate="+10%"` for pacing.
  - **structure**:
    1.  **HsiaoChen** initiates a scenario (e.g., "So, Phoebe, if we are building a high-traffic app...").
    2.  **Phoebe** responds using the episode's keywords (e.g., Latency, Throughput, Load Balancer) in full sentences.
    3.  **HsiaoChen** asks a follow-up or summarizes.
    4.  **Phoebe** gives a final tip or conclusion.
- **Language**:
  - HsiaoChen: Taiwan Traditional Chinese (Mandarin).
  - Phoebe: American English.
- **Keywords**: Try to weave in at least 3-4 keywords from the current episode naturally.

## 3. Output Format (SSML)
Produce the output as a valid XML block ready to be inserted.

```xml
  <!-- Mock Discussion Section -->
  <voice name="zh-TW-HsiaoChenNeural">
    <mstts:express-as style="cheerful">
      <prosody rate="+10%">
        [HsiaoChen's Opening Question/Scenario]
      </prosody>
    </mstts:express-as>
  </voice>

  <voice name="en-US-PhoebeMultilingualNeural">
    <mstts:express-as style="cheerful">
      <prosody rate="+10%">
        [Phoebe's Response using keywords]
      </prosody>
    </mstts:express-as>
  </voice>
  
  <!-- Add more interaction turns as needed... -->
```

## 4. Execution Steps
1.  **Identify Keywords**: Extract the English title keywords from the XML (e.g., "Latency", "Bandwidth", "Throughput").
2.  **Draft Script**: Create a dialogue scenario relevant to the episode title.
3.  **Apply Styles**: Wrap conversation in `cheerful` and `+10%` tags.
4.  **Insert**: Place this block **after** the last keyword definition/example and **before** the final Outro (e.g., before "That's it for this episode...").

## 5. Example Scenario (Episode 01 - Hardware & Network)
*HsiaoChen*: "Phoebe，我們今天聊了很多硬體跟網路協定，但在實際開發 Web App 的時候，這些真的有這麼重要嗎？"
*Phoebe*: "Absolutely. Imagine you're designing a real-time trading system. You can't just ignore **Latency**. High latency kills the user experience. You need to understand how **Packets** travel and optimize your **Bandwidth** usage."
*HsiaoChen*: "原來如此，所以優化 **Latency** 不只是改改程式碼，還跟底層協定有關囉？"
*Phoebe*: "Exactly. Sometimes switching from HTTP to a **WebSocket** protocol is the only way to get that real-time performance."
