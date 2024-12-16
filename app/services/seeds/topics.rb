module Seeds
  class Topics
    def self.call

    end

    def self.seed_a2
      a2_content = []
      a2_content.push(conversations_a2)
      a2_content.push(a2_topics)
      ActiveRecord::Base.transaction do
        d = Difficulty.find_by(level: 2)
        en = Language.english
        a2_content.each do |content|
          content.each do |passage|
            p = Passage.find_or_create_by(difficulty: d, title: passage[0])
            passage[1].each_with_index do |sentence, idx|
              prefix, content = sentence.split(': ')
              if content
                s = Sentence.find_or_create_by(language: en, passage: p, order_idx: idx + 1, prefix: prefix, content: content)
              else
                s = Sentence.find_or_create_by(language: en, passage: p, order_idx: idx + 1, content: prefix)
              end
              s.create_words_from_content(en)
            end
          end
        end
      end
    end

    def self.seed_b1
      b1_content = []
      b1_content.push(b1_topics)
      ActiveRecord::Base.transaction do
        d = Difficulty.find_by(level: 3)
        en = Language.english
        b1_content.each do |content|
          content.each do |passage|
            p = Passage.find_or_create_by(difficulty: d, title: passage[0])
            passage[1].each_with_index do |sentence, idx|
              prefix, content = sentence.split(': ')
              if content
                s = Sentence.find_or_create_by(language: en, passage: p, order_idx: idx + 1, prefix: prefix, content: content)
              else
                s = Sentence.find_or_create_by(language: en, passage: p, order_idx: idx + 1, content: prefix)
              end
              s.create_words_from_content(en)
            end
          end
        end
      end
    end

    def self.seed_a1
      a1_content = []
      a1_content.push(sports_a1)
      a1_content.push(dating_a1)
      a1_content.push(travel_a1)
      a1_content.push(food_a1)
      a1_content.push(hobby_a1)
      a1_content.push(news_a1)
      a1_content.push(career_a1)
      a1_content.push(education_a1)
      a1_content.push(health_a1)
      a1_content.push(technology_a1)
      a1_content.push(daily_life_a1)
      a1_content.push(environmental_a1)
      a1_content.push(entertainment_a1)
      a1_content.push(personal_development_a1)
      a1_content.push(community_service_a1)
      a1_content.push(cultural_a1)
      a1_content.push(social_a1)
      a1_content.push(shopping_a1)
      a1_content.push(transportation_a1)
      a1_content.push(conversations_a1)
      ActiveRecord::Base.transaction do
        d = Difficulty.find_by(level: 1)
        en = Language.english
        a1_content.each do |content|
          content.each do |passage|
            p = Passage.find_or_create_by(difficulty: d, title: passage[0])
            passage[1].each_with_index do |sentence, idx|
              prefix, content = sentence.split(': ')
              if content
                s = Sentence.find_or_create_by(language: en, passage: p, order_idx: idx + 1, prefix: prefix, content: content)
              else
                s = Sentence.find_or_create_by(language: en, passage: p, order_idx: idx + 1, content: prefix)
              end
              s.create_words_from_content(en)
            end
          end
        end
      end
    end

    def self.sports_a1
      basketball = ["Sara likes basketball.", "She plays with her team every Tuesday.", "They wear white shirts and orange balls.", "Sara passes the ball to her friends.", "They try to shoot the basket.", "Sara makes one basket today.", "Her team wins the game.", "Sara feels proud."]
      weights = ["David goes to the gym every morning.", "He uses the treadmill to walk.", "David also lifts light weights.", "He enjoys exercising.", "At the gym, David meets his friends.", "They talk and help each other.", "Going to the gym keeps David strong."]
      event = ["Last Friday, the school had a race.", "All students joined.", "Emily ran fast and won the first prize.", "Tom came second, and Lily came third.", "The race was exciting.", "Everyone clapped for the runners.", "It was a great day."]
      team = ["Lucy plays volleyball with her team.", "They practice passing and serving.", "During the game, Lucy and her teammates work together.", "They cheer each other on.", "Lucy makes good plays and blocks the ball.", "The team celebrates their win with a smile."]
      [['Basketball Game', basketball], ['Weightlifting Dave', weights], ['The School Race', event], ['Lucy plays volleyball', team]]
    end

    def self.dating_a1
      past = [
        "Last Saturday, Anna went on her first date.",
        "She met Tom at a small café.",
        "They talked about their hobbies and favorite movies.",
        "Tom was very kind and funny.",
        "They laughed a lot.",
        "After the café, they walked in the park.",
        "Anna felt happy and excited.",
        "It was a nice evening."
      ]

      present = [
        "Maria and John are dating now.",
        "They see each other every weekend.",
        "They go to the movies and have dinner together.",
        "Maria likes to cook, and John enjoys playing the guitar.",
        "They talk about their days and share their dreams.",
        "Maria and John are happy together."
      ]

      future = [
        "Next Friday, Emily will go on a date with Mark.",
        "They plan to visit a new restaurant in town.",
        "Emily is nervous but excited.",
        "She wants to talk about her favorite books and music.",
        "Mark will take her to a concert after dinner.",
        "Emily hopes they will have a great time together."
      ]

      [
        ["Anna and Tom's First Date", past],
        ["Maria and John's Current Relationship", present],
        ["Emily and Mark's Upcoming Date", future]
      ]
    end

    def self.travel_a1
      past = [
        "Last summer, John traveled to Paris.",
        "He saw the Eiffel Tower and visited museums.",
        "John took many photos and tried French food.",
        "He walked along the Seine River and enjoyed the beautiful city.",
        "John met new friends and had a wonderful vacation."
      ]

      present = [
        "Sara is traveling this weekend.",
        "She is going to the mountains with her family.",
        "They will hike and have a picnic.",
        "Sara loves nature and wants to relax.",
        "They stay in a cozy cabin and enjoy the fresh air.",
        "Sara is excited for her trip."
      ]

      future = [
        "Next month, Mike will travel to Japan.",
        "He plans to visit Tokyo and Kyoto.",
        "Mike wants to see temples and try sushi.",
        "He will stay with his cousin who lives there.",
        "Mike is learning some Japanese words and is looking forward to his adventure."
      ]

      [
        ["John's Trip to Paris", past],
        ["Sara's Weekend Mountain Adventure", present],
        ["Mike's Upcoming Journey to Japan", future]
      ]
    end

    def self.food_a1
      past = [
        "Last Sunday, Lisa baked a birthday cake.",
        "She used chocolate and strawberries.",
        "Lisa followed a recipe and mixed the ingredients carefully.",
        "She decorated the cake with candles and sprinkles.",
        "Her friends loved the cake and enjoyed eating it.",
        "Lisa was proud of her baking."
      ]

      present = [
        "Today, Tom is eating lunch at school.",
        "He has a sandwich, an apple, and a juice box.",
        "Tom likes his sandwich with cheese and ham.",
        "He shares his apple with his friend.",
        "They talk and laugh during lunch.",
        "Tom enjoys his meal and the time with his friends."
      ]

      future = [
        "Tomorrow, Tom will try a new lunch menu.",
        "He plans to bring a turkey sandwich and a banana.",
        "Tom wants to share his meal with a new student.",
        "He hopes to make a new friend during lunch.",
        "Tom is excited to try something different."
      ]

      [
        ["Lisa's Homemade Birthday Cake", past],
        ["Tom's School Lunch Today", present],
        ["Tom's New Lunch Menu Tomorrow", future]
      ]
    end

    def self.hobby_a1
      past = [
        "Last month, Alex worked on a painting project.",
        "He painted a picture of his garden.",
        "Alex used green, blue, and yellow colors.",
        "He enjoyed mixing the paints and creating shapes.",
        "The finished painting was bright and beautiful.",
        "Alex showed his artwork to his family and friends."
      ]

      present = [
        "Nina is gardening now.",
        "She plants flowers and vegetables in her backyard.",
        "Every morning, Nina waters the plants and removes weeds.",
        "She likes to see her garden grow.",
        "Nina enjoys spending time outside and caring for her plants.",
        "Her garden looks colorful and healthy."
      ]

      future = [
        "Next week, Sam will start learning to play the guitar.",
        "He bought a new guitar and is excited to practice.",
        "Sam will take lessons every Thursday.",
        "He wants to play his favorite songs.",
        "Sam hopes to perform at a school event in the future.",
        "He is looking forward to his musical journey."
      ]

      [
        ["Alex's Garden Painting Project", past],
        ["Nina's Gardening Routine", present],
        ["Sam's Guitar Learning Journey", future]
      ]
    end

    def self.news_a1
      past = [
        "Last year, a new president started working in a big country.",
        "Many people voted in the election.",
        "The president promised to help the country grow.",
        "People watched the news and learned about new plans.",
        "They hoped for a better future."
      ]

      present = [
        "This week, world leaders meet at a big conference.",
        "They talk about climate change.",
        "They want to protect the earth and help the environment.",
        "On the news, we see them shake hands and share ideas.",
        "Everyone hopes for good solutions."
      ]

      future = [
        "Next month, many countries will sign a new agreement.",
        "They want to stop pollution in the oceans.",
        "The leaders will sit together and make rules.",
        "After the meeting, they will share the news with the world.",
        "People hope the seas will be cleaner."
      ]

      [
        ["The New President's First Year", past],
        ["World Leaders' Climate Conference", present],
        ["Upcoming Global Pollution Agreement", future]
      ]
    end

    def self.career_a1
      past = [
        "Last year, Maria got her first job at a small company.",
        "She worked as an assistant.",
        "Maria learned new skills every day.",
        "She helped her boss and answered phone calls.",
        "Maria was happy to start her career."
      ]

      present = [
        "Today, David works as a teacher.",
        "He teaches young children in a classroom.",
        "David reads stories and sings songs with the students.",
        "He is patient and kind.",
        "David enjoys helping children learn."
      ]

      future = [
        "Next year, Linda will start a new job at a bank.",
        "She will help people with their money.",
        "Linda plans to learn about saving and investing.",
        "She will talk to customers and give advice.",
        "Linda is excited to begin this career."
      ]

      [
        ["Maria's First Job Experience", past],
        ["David's Teaching Career Today", present],
        ["Linda's Future at the Bank", future]
      ]
    end

    def self.education_a1
      past = [
        "Last month, Alex took a test at school.",
        "He studied hard and learned many words.",
        "Alex felt a little nervous before the test.",
        "After the test, he was proud of his work.",
        "Alex got a good grade."
      ]

      present = [
        "Today, Sarah studies English at home.",
        "She watches short videos and reads simple sentences.",
        "Sarah writes new words in her notebook.",
        "She repeats them many times.",
        "Sarah is happy when she learns something new."
      ]

      future = [
        "Next week, Daniel will go to a new school.",
        "He will meet his teacher and classmates.",
        "Daniel will learn math and science.",
        "He wants to do his best.",
        "Daniel is excited about his first day there."
      ]

      [
        ["Alex's Recent School Test", past],
        ["Sarah's English Studies Today", present],
        ["Daniel's First Day at a New School", future]
      ]
    end

    def self.art_a1
      past = [
        "Last year, Anna visited an art museum.",
        "She saw many paintings and sculptures.",
        "Anna liked a picture of a blue boat.",
        "She looked at the colors and shapes.",
        "Anna felt calm and happy."
      ]

      present = [
        "Right now, Carlos draws a picture of a cat.",
        "He uses a pencil and paper.",
        "Carlos is careful and slow.",
        "He adds details to the cat’s face.",
        "Carlos enjoys making art in his room."
      ]

      future = [
        "Next month, Maria will take a painting class.",
        "She will learn to mix colors and use a brush.",
        "Maria wants to paint flowers and trees.",
        "She hopes to make beautiful art.",
        "Maria is excited to start painting."
      ]

      [
        ["Anna's Visit to the Art Museum", past],
        ["Carlos's Current Art Project", present],
        ["Maria's Upcoming Painting Class", future]
      ]
    end

    def self.health_a1
      past = [
        "Emma felt sick last week.",
        "She had a headache and a sore throat.",
        "Her mother took her to the doctor.",
        "The doctor listened to her and gave her some medicine.",
        "Emma rested at home and felt better soon.",
        "She learned to drink more water when she is unwell."
      ]

      present = [
        "Liam eats healthy foods every day.",
        "He enjoys fruits like apples and bananas.",
        "For breakfast, he has oatmeal with berries.",
        "At lunch, Liam likes a salad with vegetables.",
        "In the evening, he eats fish and rice.",
        "Liam feels strong and full of energy because of his good eating habits."
      ]

      future = [
        "Sophia plans to start exercising next week.",
        "She wants to join a yoga class.",
        "Every morning, Sophia will do stretching exercises.",
        "She hopes to become more flexible and relaxed.",
        "Sophia is excited to try new activities and stay fit."
      ]

      [
        ["Emma's Recent Illness and Recovery", past],
        ["Liam's Daily Healthy Eating Habits", present],
        ["Sophia's Upcoming Exercise Plan", future]
      ]
    end

    def self.technology_a1
      past = [
        "Two years ago, Ben bought his first smartphone.",
        "He was very excited to use it.",
        "Ben learned to send messages and make calls.",
        "He downloaded games and took photos with his phone.",
        "Ben enjoys using his smartphone to stay connected with friends."
      ]

      present = [
        "Mia attends her classes online every day.",
        "She uses a computer and a webcam.",
        "Mia listens to her teacher and writes notes on her laptop.",
        "During breaks, she chats with her classmates through the internet.",
        "Online classes help Mia continue her education from home."
      ]

      future = [
        "Next month, Noah will receive a new tablet for school.",
        "He plans to use it for reading and doing homework.",
        "Noah wants to watch educational videos and play learning games.",
        "With his tablet, Noah hopes to study more effectively and have fun at the same time."
      ]

      [
        ["Ben's First Smartphone Experience", past],
        ["Mia's Current Online Classes", present],
        ["Noah's Future with a New Tablet", future]
      ]
    end

    def self.daily_life_a1
      past = [
        "Yesterday, Olivia went shopping at the local market.",
        "She bought fresh vegetables and fruits.",
        "Olivia also bought some bread from the bakery.",
        "She enjoyed walking through the colorful stalls and talking to the vendors.",
        "At home, Olivia prepared a delicious meal with her purchases."
      ]

      present = [
        "Every morning, Ethan wakes up at six o’clock.",
        "He brushes his teeth and takes a shower.",
        "After getting dressed, Ethan has breakfast with his family.",
        "He reads the news on his tablet while eating.",
        "By seven-thirty, Ethan leaves for school.",
        "His morning routine helps him start the day right."
      ]

      future = [
        "This weekend, Ava will visit her grandparents.",
        "She plans to help them in the garden and bake cookies together.",
        "Ava wants to watch movies and play board games with her family.",
        "She is looking forward to spending quality time and creating happy memories."
      ]

      [
        ["Olivia's Shopping Trip Yesterday", past],
        ["Ethan's Morning Routine Today", present],
        ["Ava's Weekend Visit to Grandparents", future]
      ]
    end

    def self.environmental_a1
      past = [
        "Anna and her friends organized a clean-up day last spring.",
        "They went to the local park with gloves and bags.",
        "Together, they picked up trash and recycled bottles.",
        "After a few hours, the park looked much cleaner.",
        "Anna felt proud of her work and happy to help the environment."
      ]

      present = [
        "Tom is recycling every day now.",
        "He separates his trash into different bins at home.",
        "Tom recycles paper, plastic, and glass.",
        "He also uses a reusable water bottle to reduce waste.",
        "By recycling, Tom helps protect the earth and keeps his neighborhood clean."
      ]

      future = [
        "Next month, Sara will plant trees in her community.",
        "She has joined a group that cares about the environment.",
        "Sara will plant five trees in the schoolyard.",
        "She believes that trees help clean the air and provide shade.",
        "Sara is excited to make a positive change for the environment."
      ]

      [
        ["Anna's Spring Clean-Up Event", past],
        ["Tom's Daily Recycling Habits", present],
        ["Sara's Tree Planting Initiative", future]
      ]
    end

    def self.social_a1
      past = [
        "Last weekend, Jake had a birthday party with his friends.",
        "They played games and ate cake together.",
        "Everyone enjoyed singing \"Happy Birthday.\"",
        "Jake opened his presents and thanked his friends.",
        "It was a fun and happy day for everyone."
      ]

      present = [
        "Mia is part of a study group now.",
        "Every Tuesday evening, she meets with her classmates at the library.",
        "They help each other with homework and prepare for exams.",
        "Mia enjoys talking and learning with her friends.",
        "The study group makes studying easier and more enjoyable."
      ]

      future = [
        "Next week, Lily will join a new school club.",
        "She plans to become a member of the art club.",
        "Lily is excited to meet other students who like drawing and painting.",
        "They will create art projects together and share ideas.",
        "Lily looks forward to making new friends in the club."
      ]

      [
        ["Jake's Birthday Celebration", past],
        ["Mia's Current Study Group", present],
        ["Lily's Upcoming School Club Membership", future]
      ]
    end

    def self.shopping_a1
      past = [
        "Yesterday, Ben went grocery shopping with his mother.",
        "They bought fruits, vegetables, and bread at the supermarket.",
        "Ben helped his mother choose the best apples and oranges.",
        "After shopping, they paid at the cashier and went home.",
        "Ben enjoyed helping his mother and learning about different foods."
      ]

      present = [
        "Emma is shopping online today.",
        "She wants to buy a new dress for a party.",
        "Emma browses different websites and looks at various styles.",
        "She selects a blue dress and adds it to her cart.",
        "After checking out, Emma waits for the dress to arrive at her home.",
        "Online shopping is easy and convenient for Emma."
      ]

      future = [
        "Next Saturday, Ryan will go shopping for school supplies.",
        "He needs notebooks, pens, and a backpack.",
        "Ryan will visit the stationery store with his father.",
        "They will choose colorful notebooks and a strong backpack.",
        "Ryan is excited to have all his supplies ready for the new school year."
      ]

      [
        ["Ben's Grocery Shopping with Mom", past],
        ["Emma's Online Shopping Today", present],
        ["Ryan's School Supplies Shopping Plan", future]
      ]
    end

    def self.entertainment_a1
      past = [
        "Last Friday, Sophia had a movie night with her family.",
        "They watched a fun animated film together.",
        "Sophia enjoyed the colorful characters and exciting story.",
        "After the movie, they talked about their favorite parts.",
        "It was a relaxing and enjoyable evening for Sophia and her family."
      ]

      present = [
        "Liam is going to a concert this weekend.",
        "His favorite band is performing at the local theater.",
        "Liam bought tickets online and is excited to see the show.",
        "He plans to sing along to all his favorite songs.",
        "Attending concerts is one of Liam's favorite hobbies."
      ]

      future = [
        "Next month, Olivia will start a dance class.",
        "She wants to learn how to dance ballet.",
        "Olivia is looking forward to moving gracefully and learning new steps.",
        "The class meets every Wednesday evening at the community center.",
        "Olivia hopes to become a better dancer and have fun with her classmates."
      ]

      [
        ["Sophia's Family Movie Night", past],
        ["Liam's Upcoming Concert Attendance", present],
        ["Olivia's Future Dance Class", future]
      ]
    end

    def self.personal_development_a1
      past = [
        "I remember my first public speaking event.",
        "It was at school during the spring festival.",
        "I was nervous but excited.",
        "I talked about my favorite book.",
        "My friends and teachers listened carefully.",
        "After the speech, everyone clapped for me.",
        "I felt proud and happy."
      ]

      present = [
        "Sara is working on her personal development now.",
        "She is taking an online course in photography.",
        "Every evening, Sara practices taking pictures in her garden.",
        "She reads books about camera settings and lighting.",
        "Sara enjoys learning new things and improving her skills."
      ]

      future = [
        "Tom wants to develop himself by running a marathon next year.",
        "He plans to start training this spring.",
        "Every morning, Tom will run in the park.",
        "He will follow a training schedule to build his strength.",
        "Tom believes that running a marathon will make him healthier and more disciplined."
      ]

      [
        ["My First Public Speaking Experience", past],
        ["Sara's Photography Course", present],
        ["Tom's Marathon Training Goals", future]
      ]
    end

    def self.community_service_a1
      past = [
        "Last month, Emma volunteered at the local food bank.",
        "She sorted canned goods and packed food boxes for families.",
        "Emma enjoyed helping others and meeting new people.",
        "Her friends also joined her, and together they made a big difference.",
        "Emma felt good about her work."
      ]

      present = [
        "Jake is currently organizing a charity drive in his neighborhood.",
        "He is collecting clothes and toys for children in need.",
        "Every Saturday, Jake sets up a table in the community center.",
        "People donate items and smile at Jake.",
        "Jake loves bringing the community together to help others."
      ]

      future = [
        "Lily will organize a beach clean-up next summer.",
        "She wants to keep the beaches clean and protect marine life.",
        "Lily will invite her friends and family to join the event.",
        "They will collect trash and recycle plastic bottles.",
        "Lily hopes to make a positive impact on the environment."
      ]

      [
        ["Emma's Volunteering at the Food Bank", past],
        ["Jake's Neighborhood Charity Drive", present],
        ["Lily's Beach Clean-Up Initiative", future]
      ]
    end

    def self.transportation_a1
      past = [
        "Two years ago, Ben learned to ride a bike.",
        "His father taught him in the park.",
        "Ben was scared at first, but he did not give up.",
        "After many tries, he rode without training wheels.",
        "Ben felt free and happy as he rode his bike around the park."
      ]

      present = [
        "Mia takes the bus to school every day.",
        "She waits at the bus stop with her friends.",
        "The bus arrives at 7:30 AM sharp.",
        "Mia enjoys talking to her friends during the ride.",
        "Taking the bus is easy and helps Mia save time for her studies."
      ]

      future = [
        "Next month, Alex will start driving lessons.",
        "He wants to drive a car to go to work.",
        "Alex has bought a new car for practice.",
        "Every weekend, he will go to the driving school.",
        "Alex is excited to learn and become independent."
      ]

      [
        ["Ben's Bike Riding Journey", past],
        ["Mia's Daily Bus Commute", present],
        ["Alex's Driving Lessons Ahead", future]
      ]
    end

    def self.cultural_a1
      past = [
        "Last summer, Anna visited Japan.",
        "She attended a traditional tea ceremony.",
        "Anna learned to bow respectfully before entering the room.",
        "She watched how the tea was prepared carefully.",
        "Anna enjoyed the peaceful and polite atmosphere.",
        "It was a memorable cultural experience for her."
      ]

      present = [
        "Carlos is learning about different cultural etiquettes now.",
        "He practices greeting people in various ways.",
        "In some cultures, he shakes hands, while in others, he bows or gives a hug.",
        "Carlos also learns to use polite words and gestures.",
        "Understanding cultural etiquette helps Carlos communicate better with people from different backgrounds."
      ]

      future = [
        "Sophia will attend a Korean wedding next month.",
        "She wants to respect the cultural traditions.",
        "Sophia plans to wear appropriate clothing and bring a gift.",
        "She will learn how to bow properly and participate in the ceremonies.",
        "Sophia is excited to experience and honor Korean cultural etiquette."
      ]

      [
        ["Anna's Cultural Experience in Japan", past],
        ["Carlos's Study of Cultural Etiquettes", present],
        ["Sophia's Participation in a Korean Wedding", future]
      ]
    end


    def self.conversations_a1
      [
        ["Emma's Public Speaking Experience", [
          "Emma: I remember my first public speaking event.",
          "Teacher: Oh, how did it go?",
          "Emma: I was nervous but excited. I talked about my favorite book.",
          "Teacher: Did you enjoy it?",
          "Emma: Yes, everyone clapped. I felt proud and happy."
        ]],

        ["Online Photography Course", [
          "Sara: Hi Mia, what are you doing today?",
          "Mia: Hi Sara! I'm taking an online photography course.",
          "Sara: That sounds interesting. Are you enjoying it?",
          "Mia: Yes, I love learning new things. I practice taking pictures every evening.",
          "Sara: Great! Keep it up."
        ]],

        ["Marathon Training Goal", [
          "Tom: Hey Jake, I have a new goal.",
          "Jake: Really? What is it?",
          "Tom: I want to run a marathon next year.",
          "Jake: That's amazing! How will you prepare?",
          "Tom: I will start training this spring. I hope to stay healthy and strong."
        ]],

        ["Volunteering at the Food Bank", [
          "Emma: Last month, I volunteered at the food bank.",
          "Liam: That's nice! What did you do?",
          "Emma: I sorted canned goods and packed food boxes.",
          "Liam: Did you enjoy helping?",
          "Emma: Yes, it felt good to help others. I met new people too."
        ]],

        ["Charity Drive Organization", [
          "Jake: Hi Lily, I'm organizing a charity drive this weekend.",
          "Lily: That's wonderful! What are you collecting?",
          "Jake: We're collecting clothes and toys for children.",
          "Lily: I’d love to help. When and where?",
          "Jake: Saturday at the community center from 10 AM to 2 PM."
        ]],

        ["Beach Clean-Up Event", [
          "Lily: Next month, I will organize a beach clean-up.",
          "Sophia: That sounds great! How can I join?",
          "Lily: You can bring your friends and family. We will meet at the beach at 9 AM.",
          "Sophia: I’ll be there. Let’s make the beach clean together.",
          "Lily: Perfect, I’m glad you can help."
        ]],

        ["Learning to Ride a Bike", [
          "Ben: Two years ago, I learned to ride a bike.",
          "Dad: That's right! You were very determined.",
          "Ben: I was scared at first, but I didn't give up.",
          "Dad: And now you ride every day.",
          "Ben: Yes, I feel free and happy when I ride."
        ]],

        ["Taking the Bus", [
          "Mia: Good morning, Jake!",
          "Jake: Good morning, Mia! Are you taking the bus today?",
          "Mia: Yes, I am. The bus arrives at 7:30 AM.",
          "Jake: Do you like riding the bus?",
          "Mia: Yes, I enjoy talking to my friends during the ride."
        ]],

        ["Driving Lessons Plan", [
          "Alex: Hey Tom, I have plans for next year.",
          "Tom: Oh? What are you planning to do?",
          "Alex: I will start driving lessons.",
          "Tom: That’s exciting! When will you begin?",
          "Alex: I will start next month. I want to drive to work soon."
        ]],

        ["Trip to Japan", [
          "Anna: Last summer, I visited Japan.",
          "Mia: That sounds amazing! What did you do there?",
          "Anna: I attended a traditional tea ceremony.",
          "Mia: How was it?",
          "Anna: It was peaceful. I learned to bow respectfully and watch how the tea was prepared."
        ]]
      ]
    end

    def self.conversations_a2
      [
        ["Ordering at Bella Italia", [
          "Server: Good evening, welcome to Bella Italia! May I help you with your order?",
          "Customer: Yes, I would like the spaghetti carbonara, please.",
          "Server: Excellent choice. Would you like it as it is, or do you have any special requests?",
          "Customer: Could you please make it without cheese? I cannot eat dairy.",
          "Server: Sure, we can prepare it without cheese. Would you like extra vegetables instead?",
          "Customer: Yes, that sounds great. Could you add some mushrooms and spinach?",
          "Server: Absolutely. Let me confirm: spaghetti carbonara without cheese, with mushrooms and spinach added.",
          "Customer: Perfect! That is exactly what I want.",
          "Server: Wonderful. Your meal will be ready shortly. Enjoy your dinner!"
        ]],

        ["First Dance Lesson at the Studio", [
          "Alex: Hi! It’s nice to meet you here at the dance studio.",
          "Bella: Hi Alex! I’m excited. I love dancing.",
          "Alex: Me too. Do you know this dance step?",
          "Bella: I’m not sure. Can you show me?",
          "Alex: Sure. First, stand straight. Then move your left foot forward.",
          "Bella: Okay, like this?",
          "Alex: Yes, perfect! Now add a small turn.",
          "Bella: This is fun. I feel happy dancing with you.",
          "Alex: I feel happy too. You dance very well.",
          "Bella: Thank you, Alex. Let’s keep dancing!"
        ]]
      ]
    end

    def self.a2_topics
      [
        ["Playing Soccer with Friends", [
          "Maria: Hi Tom! Do you want to play soccer this weekend?",
          "Tom: Sure, Maria! I love soccer. Where should we go?",
          "Maria: There's a new park near my house. It's perfect for a game.",
          "Tom: Great! I felt excited when I saw the park last week. The field looks big and green.",
          "Maria: Awesome! I'll bring the soccer ball. Do you have your cleats?",
          "Tom: Yes, I do. I wore them last Saturday. They are very comfortable.",
          "Maria: Perfect. I’m looking forward to our game. It will be fun!",
          "Tom: Me too! Let’s invite some friends to join us."
        ]],

        ["Meeting at the Café", [
          "Emma: Hi Jake! It’s nice to meet you in person.",
          "Jake: Hi Emma! I’m happy to finally see you. How are you today?",
          "Emma: I’m good, thank you. The café looks cozy, doesn’t it?",
          "Jake: Yes, it does. I felt a bit nervous, but now I’m relaxed.",
          "Emma: That’s understandable. I’m excited to talk and get to know each other.",
          "Jake: Me too. What do you like to do in your free time?",
          "Emma: I enjoy reading and going for walks. How about you?",
          "Jake: I love playing guitar and watching movies. Maybe we can do something together sometime.",
          "Emma: I’d like that. Let’s plan something fun soon!"
        ]],

        ["Planning a Trip to Paris", [
          "Liam: Hey Sophie, I’m thinking about visiting Paris next summer. What do you think?",
          "Sophie: That sounds amazing! I’ve always wanted to see the Eiffel Tower.",
          "Liam: Yes, and we can visit the Louvre Museum too. It has many beautiful paintings.",
          "Sophie: I’m excited! Have you booked the flights yet?",
          "Liam: Not yet. I will book them tomorrow. We should also find a good hotel.",
          "Sophie: Good idea. I felt happy when I saw pictures of Paris online. It looks so romantic.",
          "Liam: Me too. Let’s make a list of places we want to visit.",
          "Sophie: Sure! I can’t wait for our adventure."
        ]],

        ["Gardening as a Hobby", [
          "Jake: I spend every Saturday morning gardening. It’s my favorite hobby.",
          "Friend: That sounds nice, Jake. What do you like to grow?",
          "Jake: I grow flowers and vegetables. Last week, I planted tomatoes and sunflowers.",
          "Friend: Wow! How do you take care of them?",
          "Jake: I water them every day and make sure they get enough sunlight. It makes me happy to see them grow.",
          "Friend: I’d like to try gardening too. It must be relaxing.",
          "Jake: You should! It’s a great way to spend time outdoors and enjoy nature.",
          "Friend: Maybe next weekend, you can show me your garden.",
          "Jake: I’d love to. Let’s plan for it!"
        ]],

        ["Climate Change Summit", [
          "The United Nations held a summit yesterday to discuss climate change.",
          "Leaders from around the world attended the meeting.",
          "They shared their plans to reduce carbon emissions by 2030.",
          "Maria, a reporter, asked the delegates about their commitments.",
          "One delegate responded, 'We are committed to investing in renewable energy sources.'",
          "The summit concluded with a unanimous agreement to take immediate action."
        ]],

        ["Job Interview Preparation", [
          "John is preparing for his job interview next week.",
          "He practices answering common interview questions with his friend, Lisa.",
          "John: I am excited about this opportunity. Can you help me with my resume?",
          "Lisa: Sure, John. Let's highlight your skills and experiences relevant to the job.",
          "They review his resume together, making sure it showcases his strengths.",
          "John feels more confident after the practice session."
        ]],

        ["Improving Spanish with Online Courses", [
          "Sara attends an online course to improve her Spanish.",
          "She finds the interactive lessons very engaging.",
          "Every evening, she dedicates two hours to studying.",
          "Sara: I enjoy learning new vocabulary and practicing conversations.",
          "Her teacher provides feedback to help her progress.",
          "Sara feels motivated as she notices her improvement each week."
        ]],

        ["Adopting a Healthier Lifestyle", [
          "Tom decided to adopt a healthier lifestyle.",
          "He starts by eating more vegetables and fruits.",
          "Tom joins a local gym to exercise regularly.",
          "He also schedules annual check-ups with his doctor.",
          "Tom: I want to feel more energetic and reduce my stress levels.",
          "After a few months, Tom notices significant improvements in his health."
        ]],

        ["Excitement About a New Smartphone", [
          "Emma is excited about the latest smartphone release.",
          "She visits the store to see the new features.",
          "Salesperson: This model has an improved camera and longer battery life.",
          "Emma tries out the phone and takes some pictures.",
          "She appreciates the sleek design and user-friendly interface.",
          "Emma decides to purchase the smartphone to enhance her daily tasks."
        ]],

        ["A Day in My Life", [
          "I wake up at 5:30 every morning.",
          "First, I work on my side project for one hour.",
          "I enjoy creating new ideas and solving problems.",
          "After my project, I get ready for work.",
          "I leave the house at 7:00 and take the bus to my office.",
          "At 6:00 in the evening, I go to the gym to exercise.",
          "After the gym, I return home to my wife and kids.",
          "We have dinner together and talk about our day.",
          "Before bed, I read a book to relax."
        ]],

        ["Autumn Season Description", [
          "Autumn is my favorite season.",
          "The trees change their colors to red, orange, and yellow.",
          "Leaves fall gently to the ground, creating a colorful carpet.",
          "The air feels cool and fresh.",
          "I love walking in the park during autumn.",
          "The sunsets are beautiful with warm colors.",
          "Birds fly south to find warmer places.",
          "Autumn is a time of change and beauty."
        ]],

        ["Concert Night with Friends", [
          "Last weekend, I went to a concert with my friends.",
          "The band played many popular songs.",
          "The music was loud and exciting.",
          "We danced and sang along to the tunes.",
          "After the concert, we had ice cream at a nearby shop.",
          "It was a fun evening full of laughter and joy.",
          "I love spending time with friends at events like this.",
          "Music brings us together and creates happy memories."
        ]],

        ["Developing Good Habits to Reach Goals", [
          "I want to reach my goals this year.",
          "To do that, I need to develop good habits.",
          "Every morning, I wake up early and exercise.",
          "I also make a to-do list to stay organized.",
          "Reading books helps me learn new things.",
          "I practice time management to use my day wisely.",
          "Staying positive keeps me motivated.",
          "With these habits, I believe I can achieve my dreams."
        ]],

        ["Community Service and Helping Orphans", [
          "I love helping others in my community.",
          "Every Saturday, my friend Anna and I go to a community center.",
          "We help take care of orphans in less privileged areas.",
          "We prepare meals and organize activities for the children.",
          "Anna and I feel happy when we see the children smile.",
          "Sometimes, we read stories and play games with them.",
          "Helping others makes me feel fulfilled and grateful.",
          "I look forward to our community service every week."
        ]],

        ["Cultural Heritage of South Korea", [
          "South Korea has a rich cultural heritage.",
          "One important tradition is the celebration of Chuseok.",
          "Chuseok is a harvest festival that takes place in the fall.",
          "People visit their families and share traditional foods.",
          "Hanbok, the traditional Korean clothing, is worn during festivals.",
          "South Korea is also known for its beautiful temples and palaces.",
          "K-pop and Korean dramas are popular around the world.",
          "The culture of South Korea blends modern and traditional elements seamlessly."
        ]],

        ["Skating Rink Outing with Friends", [
          "Alex: Hi! I'm so glad we could come to the skating rink together.",
          "Jamie: Me too, Alex! I've been looking forward to this all week.",
          "Alex: You skate really well. I love watching you glide on the ice.",
          "Jamie: Thank you! You make it look easy. Maybe you can teach me some moves.",
          "Alex: I'd love to. How about we start with some simple spins?",
          "Jamie: Sounds fun! I'm excited to learn from you.",
          "Alex: You're doing great! Your smile makes skating even more enjoyable.",
          "Jamie: You're very kind, Alex. I'm having a wonderful time with you.",
          "Alex: Let's grab some hot chocolate after skating. It's a perfect day.",
          "Jamie: That sounds perfect. I can't wait!"
        ]]
      ]
    end

    def self.b1_topics
      [
        ["Final Match Excitement in the Stadium", [
          "I remember sitting in the crowded stadium, feeling both nervous and excited as the final match approached.",
          "Our local football team, the Tigers, had trained for months to reach this championship game.",
          "They stepped onto the field with determined faces, their red and white jerseys shining under the bright lights.",
          "From my seat, I could see the tension in the players’ eyes as they prepared to face their strongest rivals.",
          "Suddenly, the whistle blew, and everyone focused on the ball as it flew through the air.",
          "I cheered loudly each time the Tigers passed the ball with skill and confidence.",
          "Although I could barely sit still, the team remained calm, controlling the pace of the match.",
          "In the end, when the referee signaled the final goal, the entire stadium erupted with joy and pride."
        ]],

        ["Motorbike Journey Through Vietnam", [
          "Last year, I spent twelve months traveling through Vietnam on a motorbike.",
          "The country’s landscapes amazed me, from green rice fields to busy city streets.",
          "Every morning, I packed my small bag, checked my bike, and set off for a new place.",
          "As I rode along quiet roads, I met friendly locals who shared their stories and offered me tea.",
          "In small villages, I learned about traditional crafts and tasted fresh fruit I had never tried before.",
          "Sometimes I stayed in simple guesthouses, where I met other travelers and exchanged advice.",
          "By the end of the year, I had formed lasting friendships and gained a deeper respect for Vietnamese culture.",
          "The experience taught me independence, patience, and a love for life on the road."
        ]],

        ["Making Fresh Pasta at Home", [
          "Making fresh pasta at home is a simple yet rewarding process.",
          "First, combine flour and a few eggs in a large bowl, then mix them until they form a smooth dough.",
          "After kneading the dough for several minutes, cover it and let it rest.",
          "Meanwhile, prepare a tasty tomato sauce by heating olive oil in a pan and adding finely chopped onions and garlic.",
          "Once they turn soft, add crushed tomatoes, a pinch of salt, and a few fresh basil leaves.",
          "Simmer the sauce gently so the flavors can blend together.",
          "Roll out the dough until it’s thin, then cut it into long strips to form pasta ribbons.",
          "Finally, cook the pasta in boiling water and serve it with the fragrant tomato sauce on top."
        ]],

        ["Weekend Camping in the Mountains", [
          "I enjoy spending my weekends camping in the mountains near a quiet lake.",
          "Early in the morning, I set up my tent under tall pine trees and breathe in the cool, fresh air.",
          "As the sun rises, I take my fishing rod and walk slowly to the edge of the lake.",
          "Casting the line into the calm water, I wait patiently for a fish to bite.",
          "Even if I catch nothing, I find peace in the gentle sound of water and birds singing nearby.",
          "Later, I explore small trails leading deeper into the forest, discovering wildflowers and hidden streams.",
          "Back at my campsite, I relax by a small fire, enjoying the warmth and simplicity of nature.",
          "These quiet moments in the mountains help me feel refreshed and ready for the week ahead."
        ]],

        ["History of South American Indigenous People", [
          "The indigenous people of South America have a rich and diverse history that spans thousands of years.",
          "Before the arrival of Europeans, numerous advanced civilizations thrived in the region, including the Inca, Maya, and Aztec.",
          "These societies built impressive cities, developed complex agricultural systems, and created intricate art and architecture.",
          "The Inca Empire, for example, was renowned for its extensive road networks and stunning structures like Machu Picchu.",
          "Indigenous communities maintained their traditions and languages despite facing challenges and changes over the centuries.",
          "Today, their cultural heritage continues to influence modern South American societies, preserving ancient customs and knowledge.",
          "Efforts are being made to protect indigenous rights and promote the preservation of their languages and traditions.",
          "Understanding the history of South America's indigenous people is essential for appreciating the continent's cultural diversity and resilience."
        ]],

        ["Career Decisions After High School", [
          "Emma: Hey Liam, have you thought about what you want to do after high school?",
          "Liam: Yeah, I've been considering a few options.",
          "Liam: I'm not sure whether to start a trade, go to college, or maybe even start my own business.",
          "Emma: Those are all great choices.",
          "Emma: What interests you the most?",
          "Liam: I really like working with my hands, so a trade like carpentry or plumbing could be a good fit.",
          "Liam: But I also enjoy learning new things, so college is appealing too.",
          "Emma: True. College can open up many opportunities, but starting a trade can get you into the workforce faster.",
          "Emma: Have you thought about what business you might want to start?",
          "Liam: I've always had ideas for a small tech startup, but I'm not sure if I have the right skills yet.",
          "Emma: Maybe you could combine your interests.",
          "Emma: You could start with a trade and take some college courses on the side, or look for business programs that focus on trades.",
          "Liam: That's a good point.",
          "Liam: I guess it's about finding a balance between what I enjoy and what will provide stability.",
          "Emma: Exactly. It might also help to talk to a career counselor or shadow professionals in each field to see what suits you best.",
          "Liam: Thanks, Emma. I appreciate your advice.",
          "Liam: I'll start exploring these options more."
        ]],

        ["Maintaining a Balanced Lifestyle", [
          "Maintaining a balanced lifestyle is crucial for overall health and well-being.",
          "Balance involves managing different aspects of life, including physical activity, nutrition, mental health, and rest.",
          "Regular exercise helps keep the body strong and reduces the risk of chronic diseases.",
          "Eating a balanced diet, rich in fruits, vegetables, and whole grains, provides the necessary nutrients for energy and growth.",
          "Mental health is equally important; practices like meditation, hobbies, and social interactions can reduce stress and improve mood.",
          "Adequate sleep is essential for the body to repair itself and for the mind to function properly.",
          "Balancing work or school with leisure time prevents burnout and promotes a healthier, happier life.",
          "By prioritizing balance, individuals can achieve their health goals and enjoy a higher quality of life."
        ]],

        ["The Impact of the Internet", [
          "The invention of the internet has revolutionized the way we live, work, and communicate.",
          "Originally developed in the late 20th century, the internet was created to share information quickly and efficiently.",
          "With the advent of the World Wide Web, accessing vast amounts of information became easier than ever before.",
          "The internet has transformed industries such as education, by enabling online learning, and commerce, through e-commerce platforms.",
          "Social media has changed how people interact, allowing individuals to connect with others around the globe instantly.",
          "Communication tools like email, video conferencing, and instant messaging have made remote work and collaboration more feasible.",
          "Entertainment has also been impacted, with streaming services providing on-demand access to movies, music, and games.",
          "However, the internet has also introduced challenges, including concerns about privacy, cybersecurity, and the spread of misinformation.",
          "Despite these issues, the internet continues to evolve, driving innovation and shaping the future of society in profound ways."
        ]],

        ["Understanding Global Warming", [
          "Global warming is one of the most pressing issues facing our planet today.",
          "It refers to the gradual increase in Earth's average temperature due to human activities.",
          "The burning of fossil fuels, such as coal and oil, releases large amounts of carbon dioxide into the atmosphere.",
          "This greenhouse gas traps heat from the sun, causing temperatures to rise.",
          "As a result, we are witnessing more extreme weather events, including hurricanes, droughts, and floods.",
          "Melting polar ice caps and rising sea levels are also direct consequences of global warming.",
          "Forests and wildlife are being threatened as their natural habitats change or disappear.",
          "To combat global warming, it is essential to reduce carbon emissions and switch to renewable energy sources.",
          "Individuals can contribute by conserving energy, recycling, and supporting environmentally friendly policies.",
          "Addressing global warming requires global cooperation and immediate action to ensure a sustainable future for all."
        ]],

        ["The Importance of Grit", [
          "Grit is a key trait that contributes to personal and professional success.",
          "It is defined as the perseverance and passion to achieve long-term goals.",
          "People with grit are able to stay focused and maintain their efforts despite challenges and setbacks.",
          "Developing grit involves setting clear objectives and staying committed to them over time.",
          "One important aspect of grit is resilience—the ability to recover quickly from difficulties.",
          "Another component is a strong work ethic, which drives individuals to put in the necessary effort.",
          "Gritty individuals often seek continuous improvement and are not afraid to take risks.",
          "Research has shown that grit is a better predictor of success than intelligence or talent alone.",
          "To build grit, it is helpful to cultivate a growth mindset, believing that abilities can be developed through dedication.",
          "By developing grit, people can overcome obstacles, achieve their goals, and lead fulfilling lives."
        ]],

        ["Benefits of Community Service", [
          "Engaging in community service is a meaningful way to bring joy into one's life.",
          "Volunteering allows individuals to connect with others and make a positive impact on their communities.",
          "Whether it's helping at a local shelter, organizing a neighborhood cleanup, or tutoring children, every act of service counts.",
          "Participating in community service can provide a sense of purpose and fulfillment.",
          "It also offers opportunities to develop new skills and gain valuable experiences.",
          "Moreover, volunteering can strengthen social bonds and foster a sense of belonging.",
          "Many people find that giving back to their community enhances their overall well-being and happiness.",
          "Community service encourages empathy and understanding, as volunteers work alongside diverse groups of people.",
          "By dedicating time and effort to help others, individuals can create lasting positive change.",
          "Ultimately, community service not only benefits those in need but also enriches the lives of the volunteers themselves."
        ]],

        ["Role of Dance in the Latin Community", [
          "Dance plays a significant role in the Latin community, reflecting its vibrant culture and rich traditions.",
          "From salsa and bachata to tango and merengue, Latin dances are known for their energetic and expressive movements.",
          "These dances often tell stories of love, joy, and everyday life, connecting dancers to their heritage.",
          "Music is an integral part of Latin dance, with rhythms that inspire passion and creativity.",
          "Social gatherings and festivals frequently feature dance performances, bringing people together to celebrate.",
          "Learning Latin dance can foster a sense of community and belonging among participants.",
          "Dance schools and clubs provide spaces where individuals can practice and enjoy these cultural expressions.",
          "In addition to entertainment, Latin dance promotes physical fitness and coordination.",
          "Through dance, the Latin community preserves its cultural identity and passes traditions down to future generations.",
          "Overall, dance is not just an art form but a vital aspect of cultural life in the Latin community, embodying its spirit and diversity."
        ]],

        ["Planning an Evening Out", [
          "Sarah: Hey Mike, what do you feel like doing tonight?",
          "Mike: I'm not sure. Maybe we could go to that new restaurant downtown.",
          "Sarah: That sounds good, but I was also thinking about seeing a movie. There's a great comedy playing.",
          "Mike: True, I've heard the reviews are excellent. Or we could go to a concert if you're up for some live music.",
          "Sarah: Live music sounds fun! What kind of bands are playing?",
          "Mike: There's a jazz band and an indie rock group. Which one do you prefer?",
          "Sarah: I love jazz! It would be a nice change from our usual outings.",
          "Mike: Perfect, let's go to the jazz concert then. After that, we can grab a late-night coffee.",
          "Sarah: Sounds like a plan. I'm excited for the evening!",
          "Mike: Me too. It'll be a great way to relax and enjoy some good music together."
        ]]
      ]
    end

  end
end
