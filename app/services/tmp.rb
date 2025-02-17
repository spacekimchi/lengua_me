require 'csv'

class Tmp
  def self.available_languages
    ["Spanish (Spain)", "Spanish (Latin America)", "Korean", "Japanese", "Hindi", "French", "Italian", "Portuguese", "German", "Russian", "Mandarin", "Vietnamese", "Cantonese"]
  end

  def self.fix_category_conversations
    titles = ["Emma's Public Speaking Experience", "Online Photography Course", "Marathon Training Goal", "Volunteering at the Food Bank", "Charity Drive Organization", "Beach Clean-Up Event", "Learning to Ride a Bike", "Taking the Bus", "Driving Lessons Plan", "Trip to Japan", "Ordering at Bella Italia", "First Dance Lesson at the Studio", "Booking a Hotel Room", "At the Grocery Store", "Playing Soccer with Friends", "Meeting at the Café", "Planning a Trip to Paris", "Gardening as a Hobby", "Career Decisions After High School", "Planning an Evening Out", "Volunteering at a Community Event", "Planning a Trip with Friends", "Starting a Cooking Class", "Balancing Work and Personal Life", "Exploring Career Opportunities Abroad", "Navigating Mental Health Challenges", "Embracing Sustainable Living Practices", "The Influence of Social Media on Relationships"]
    titles.each do |title|
      Passage.where(title: titles).update_all(category: :conversation)
    end
  end
end
