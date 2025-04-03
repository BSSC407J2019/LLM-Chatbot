import Array "mo:base/Array";
import LLM "mo:llm";

actor {
  type ChatMessage = LLM.ChatMessage;
  type Role = LLM.Role;

  public func prompt(prompt : Text) : async Text {
    await LLM.prompt(#Llama3_1_8B, prompt);
  };

  public func chat(messages : [ChatMessage]) : async Text {
    let lastMessage = messages[messages.size() - 1].content;

    if (lastMessage == "What is tax?" or lastMessage == "Define tax") {
        return "Tax is a mandatory financial charge or levy imposed by a government on individuals and businesses to fund public expenditures such as infrastructure, healthcare, and education.";
    };

    if (lastMessage == "What does KRA stand for?" or lastMessage == "What is KRA?") {
        return "KRA stands for Kenya Revenue Authority. It is the government agency responsible for tax collection in Kenya.";
    };

 if (lastMessage == "What does eTIMS stand for?" or lastMessage == "What is eTIMS?") {
        return "eTIMS (electronic Tax Invoice Management System) is a software solution that provides taxpayers with options for a simple, convenient and flexible approach to electronic invoicing. Taxpayers can access eTIMS on various computing devices, including computers, laptops, tablets, smartphones, and Personal Digital Assistants (PDAs).";
    };

 if (lastMessage == "What does VAT stand for?" or lastMessage == "What is VAT?") {
        return "VAT is an indirect tax that is paid by the person who consumes taxable goods and taxable services supplied in Kenya and/or imported into Kenya. VAT on goods and services supplied in Kenya is collected at designated points by VAT registered persons who act as the agents of the Government.";
    };

    if (lastMessage == "How do I get a KRA PIN?" or lastMessage == "Guide me on KRA PIN registration") {
        return "To get a KRA PIN, follow these steps:\n\n" # 
               "1️⃣ Go to: https://itax.kra.go.ke/KRA-Portal/\n" #
               "2️⃣ Click on 'New PIN Registration' for individuals.\n" #
               "3️⃣ Under 'Tax Type', select 'Individual'.\n" #
               "4️⃣ Under 'Mode of Registration', select 'Online'.\n" #
               "5️⃣ Select 'No' on the last prompt.\n" #
               "6️⃣ On 'Basic Information' tab, fill in details as per your ID card.\n" #
               "7️⃣ Click 'Next' and fill in only 'Income Tax Resident' and 'Registration Date'.\n" #
               "8️⃣ Under 'Section C', select 'No' for all questions.\n" #
               "9️⃣ Click 'Next' and in 'Section F', answer only the arithmetic question.\n" #
               "🔟 Submit the form to generate your KRA PIN Certificate!";
    };
    
    if (lastMessage == "When are tax returns filed in Kenya?" or 
        lastMessage == "Tell me about tax filing deadlines" or 
        lastMessage == "What are nil returns?" or 
        lastMessage == "How often are VAT returns filed?") {
        return "Tax Filing Information in Kenya:\n\n" #
               "1️⃣ Nil Returns and PAYE/Employed Returns:\n" #
               "   - Filed once a year before 30th June of every year\n" #
               "   - Nil returns are for unemployed people who have no source of income or earn less than 25,000 KSh\n\n" #
               "2️⃣ VAT Tax Returns:\n" #
               "   - Filed on a monthly basis\n" #
               "   - Due by the 20th day of the following month";
    };
    
    if (lastMessage == "How do I file nil returns?" or 
        lastMessage == "Guide me on filing nil returns" or 
        lastMessage == "What is the process for filing nil returns?") {
        return "Process of Filing Nil Returns in Kenya:\n\n" #
               "1️⃣ Visit the KRA portal: https://www.kra.go.ke/our-online-services\n" #
               "2️⃣ Input your PIN and press 'Continue'\n" #
               "3️⃣ Enter your password and complete the security stamp verification\n" #
               "4️⃣ Click 'Log In'\n" #
               "5️⃣ Hover your cursor on 'Returns' and select 'File Nil Returns'\n" #
               "6️⃣ Your tax type and PIN will be displayed automatically\n" #
               "7️⃣ Under the 'Tax Obligation' button, select the appropriate option based on your citizenship status\n" #
               "8️⃣ Press 'Next'\n" #
               "9️⃣ If you've been filing yearly, the tax filing periods will be filled automatically\n" #
               "🔟 If this is your first time filing or you haven't been filing yearly, you'll need to input the start dates\n" #
               "1️⃣1️⃣ The system will automatically fill the end dates\n" #
               "1️⃣2️⃣ Submit your returns";
    };

    // Use Array.map() to transform messages into the required format
    let formattedMessages = Array.map<ChatMessage, { role: Role; content: Text }>(
      messages, 
      func(message) {
        { role = message.role; content = message.content }
      }
    );

    // Create system message with the same type as formattedMessages
    let systemMessage : [{ role : Role; content : Text }] = [
        { 
            role = #system_;
            content = "You are a helpful AI assistant specialized in Kenya's taxation system. 
                       You provide information on income tax, VAT, corporate tax, and other tax-related matters 
                       in Kenya based on KRA guidelines. Always give clear, concise, and accurate responses.
                       Remember that nil and PAYE/employed returns are filed once a year before 30th June of every year.
                       Nil returns are for unemployed people who have no source of income or earn less than 25,000 KSh.
                       VAT tax returns are filed on a monthly basis.
                       
                       Process for filing nil returns:
                       1. Visit https://www.kra.go.ke/our-online-services
                       2. Input your PIN and password, complete security verification
                       3. After logging in, hover on 'Returns' and select 'File Nil Returns'
                       4. Your tax type and PIN will display automatically
                       5. Select appropriate option under 'Tax Obligation' based on citizenship
                       6. For regular filers, tax periods fill automatically; new filers must input start dates
                       7. System will fill end dates automatically
                       8. Submit your returns";
        }
    ];

    // Use Array.append instead of # operator to avoid type errors
    return await LLM.chat(#Llama3_1_8B, Array.append(systemMessage, formattedMessages));
  };
};