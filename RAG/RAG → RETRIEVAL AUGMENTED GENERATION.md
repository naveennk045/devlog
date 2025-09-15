## What is RAG?

Retrieval-augmented generation (RAG) is a framework that enhances a large language model with an external data fetching or retrieving mechanism. When you ask a question, the RAG system first searches a knowledge base (database, internal documents, etc.) for relevant information. It then adds this retrieved information to your original question and feeds both to the LLM. This provides the LLM with context – the question and supporting documents – allowing it to generate more accurate, factually correct answers grounded in the provided information.

#### Breaking the concepts down:

- **Retrieval:** A tool or system searches a specific knowledge source (like your documents stored in [Google Drive](https://www.apideck.com/connectors/google-drive)) for information relevant to your query before the LLM generates an answer.
- **Augment:** This retrieved information (context) is added to your original query, creating an 'augmented' or expanded prompt.
- **Generation:** The LLM then uses this augmented prompt (original query + retrieved context) to generate an answer grounded in the provided information, making it more accurate and relevant.
## Why ?

- Hallucination
- Lack of external data , external data in the sense like from the websites , other data bases etc..
- It is effective than other fine tuning techniques like prompting technique

##### [[Terminologies.canvas|Other things to consider before jumping into the implementation]]