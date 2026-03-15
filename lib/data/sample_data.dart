import '../models/models.dart';

final List<Category> categories = [
  Category(
    id: 'tasks',
    name: 'Tasks',
    description: 'Productivity and task prompts',
    icon: 'task',
    color: '#0A7EA4',
    promptCount: 15,
  ),
  Category(
    id: 'images',
    name: 'Images',
    description: 'Image generation prompts',
    icon: 'image',
    color: '#8B5CF6',
    promptCount: 20,
  ),
  Category(
    id: 'videos',
    name: 'Videos',
    description: 'Video creation prompts',
    icon: 'video',
    color: '#F59E0B',
    promptCount: 10,
  ),
  Category(
    id: 'writing',
    name: 'Writing',
    description: 'Content writing prompts',
    icon: 'edit',
    color: '#22C55E',
    promptCount: 12,
  ),
  Category(
    id: 'coding',
    name: 'Coding',
    description: 'Programming prompts',
    icon: 'code',
    color: '#EF4444',
    promptCount: 8,
  ),
  Category(
    id: 'education',
    name: 'Education',
    description: 'Learning prompts',
    icon: 'school',
    color: '#06B6D4',
    promptCount: 18,
  ),
];

final List<Prompt> prompts = [
  Prompt(
    id: '1',
    title: 'Professional Email Writer',
    description: 'Write professional emails for various business scenarios',
    content: '''Write a professional email for the following scenario:

[SCENARIO]: [YOUR SCENARIO HERE]

Requirements:
- Formal tone
- Clear and concise
- Professional greeting and closing
- Include relevant details

Subject: [EMAIL SUBJECT]

Body:
[GENERATE YOUR EMAIL HERE]''',
    category: 'tasks',
    author: 'PromptStore',
    createdAt: DateTime(2024, 1, 15),
    usageCount: 1250,
    tags: ['email', 'business', 'professional'],
    imageUrl: 'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=800',
  ),
  Prompt(
    id: '2',
    title: 'Midjourney Portrait',
    description: 'Create realistic portrait images',
    content: '''Create a portrait image with the following specifications:

Style: [REALISTIC/PHOTOREALISTIC/ARTISTIC]
Subject: [DESCRIBE YOUR SUBJECT]
Lighting: [NATURAL/STUDIO/DRAMATIC]
Mood: [SERIOUS/HAPPY/MYSTICAL]
Additional details: [ANY OTHER DETAILS]

Use high quality, 8k resolution, detailed features.''',
    category: 'images',
    author: 'PromptStore',
    createdAt: DateTime(2024, 1, 20),
    usageCount: 980,
    tags: ['portrait', 'midjourney', 'AI art'],
    imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800',
  ),
  Prompt(
    id: '3',
    title: 'YouTube Video Script',
    description: 'Generate engaging video scripts',
    content: '''Create a YouTube video script for:

Topic: [YOUR TOPIC]
Duration: [TARGET DURATION]
Tone: [EDUCATIONAL/ENTERTAINING/CASUAL]

Include:
- Hook (first 10 seconds)
- Main content points (3-5 key points)
- Call to action
- End screen suggestions

Target audience: [YOUR AUDIENCE]''',
    category: 'videos',
    author: 'PromptStore',
    createdAt: DateTime(2024, 2, 1),
    usageCount: 756,
    tags: ['youtube', 'script', 'video'],
    imageUrl: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?w=800',
  ),
  Prompt(
    id: '4',
    title: 'Blog Post Generator',
    description: 'Write SEO-friendly blog posts',
    content: '''Write a comprehensive blog post on:

Title: [YOUR TITLE]
Target keywords: [KEYWORD 1, KEYWORD 2, KEYWORD 3]
Word count: [TARGET WORD COUNT]

Structure:
1. Introduction (hook + topic introduction)
2. H2: [SUBHEADING 1]
3. H2: [SUBHEADING 2]
4. H2: [SUBHEADING 3]
5. Conclusion

Include SEO-optimized content with naturally integrated keywords.''',
    category: 'writing',
    author: 'PromptStore',
    createdAt: DateTime(2024, 2, 10),
    usageCount: 654,
    tags: ['blog', 'SEO', 'writing'],
    imageUrl: 'https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=800',
  ),
  Prompt(
    id: '5',
    title: 'Code Review Assistant',
    description: 'Get comprehensive code reviews',
    content: '''Review the following code and provide feedback on:

[PASTE YOUR CODE HERE]

Focus on:
- Code quality and best practices
- Potential bugs or errors
- Performance optimization
- Security concerns
- Readability and maintainability

Provide a detailed analysis with specific suggestions for improvement.''',
    category: 'coding',
    author: 'PromptStore',
    createdAt: DateTime(2024, 2, 15),
    usageCount: 432,
    tags: ['code review', 'programming', 'development'],
    imageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800',
  ),
  Prompt(
    id: '6',
    title: 'Quiz Generator',
    description: 'Create educational quizzes',
    content: '''Generate a quiz on:

Topic: [YOUR TOPIC]
Number of questions: [NUMBER]
Difficulty: [EASY/MEDIUM/HARD]
Format: [MCQ/TRUE-FILL/BOTH]

Include:
- Clear question statements
- 4 options for MCQ (A, B, C, D)
- Correct answers
- Brief explanations''',
    category: 'education',
    author: 'PromptStore',
    createdAt: DateTime(2024, 2, 20),
    usageCount: 521,
    tags: ['quiz', 'education', 'learning'],
    imageUrl: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800',
  ),
  Prompt(
    id: '7',
    title: 'Stable Diffusion Landscape',
    description: 'Create stunning landscape images',
    content: '''Generate a breathtaking landscape image:

Setting: [MOUNTAINS/BEACH/FOREST/CITYSCAPE]
Time of day: [DAWN/NOON/SUNSET/NIGHT]
Weather: [CLEAR/CLOUDY/FOGGY/RAINY]
Style: [REALISTIC/PAINTING/DIGITAL ART]

Include:
- Detailed environment
- Proper lighting and shadows
- Atmospheric effects
- 8K resolution, photorealistic quality''',
    category: 'images',
    author: 'PromptStore',
    createdAt: DateTime(2024, 3, 1),
    usageCount: 887,
    tags: ['landscape', 'stable diffusion', 'art'],
    imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
  ),
  Prompt(
    id: '8',
    title: 'Meeting Summary',
    description: 'Summarize meeting notes effectively',
    content: '''Summarize the following meeting notes:

[PASTE MEETING NOTES]

Provide:
- Key discussion points
- Decisions made
- Action items with owners
- Next steps
- Follow-up timeline''',
    category: 'tasks',
    author: 'PromptStore',
    createdAt: DateTime(2024, 3, 5),
    usageCount: 445,
    tags: ['meeting', 'summary', 'productivity'],
    imageUrl: 'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=800',
  ),
  Prompt(
    id: '9',
    title: 'Social Media Caption',
    description: 'Write engaging social media posts',
    content: '''Create a social media caption for:

Platform: [INSTAGRAM/TWITTER/LINKEDIN]
Content type: [POST/STORY/REELS]
Topic: [YOUR TOPIC]

Include:
- Catchy headline
- Engaging body text (150-300 words for post)
- 5-10 relevant hashtags
- Call to action''',
    category: 'writing',
    author: 'PromptStore',
    createdAt: DateTime(2024, 3, 10),
    usageCount: 678,
    tags: ['social media', 'caption', 'marketing'],
    imageUrl: 'https://images.unsplash.com/photo-1611162616305-c69b3fa7fbe0?w=800',
  ),
  Prompt(
    id: '10',
    title: 'Video Tutorial Outline',
    description: 'Plan educational video tutorials',
    content: '''Create an outline for a video tutorial on:

Topic: [YOUR TOPIC]
Duration: [TARGET DURATION]
Skill level: [BEGINNER/INTERMEDIATE/ADVANCED]

Include:
- Learning objectives
- Section breakdown with timestamps
- Key points for each section
- Practice exercises
- Summary and next steps''',
    category: 'videos',
    author: 'PromptStore',
    createdAt: DateTime(2024, 3, 15),
    usageCount: 334,
    tags: ['tutorial', 'video', 'education'],
    imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800',
  ),
];
