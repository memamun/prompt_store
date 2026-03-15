import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class PromptBuilderModal extends StatefulWidget {
  final String? initialTemplate;
  final String? initialContent;

  const PromptBuilderModal({
    super.key,
    this.initialTemplate,
    this.initialContent,
  });

  @override
  State<PromptBuilderModal> createState() => _PromptBuilderModalState();
}

class _PromptBuilderModalState extends State<PromptBuilderModal> {
  String _selectedTemplate = '';
  final Map<String, TextEditingController> _variableControllers = {};
  String _generatedPrompt = '';

  final List<Map<String, dynamic>> _templates = [
    {
      'name': 'Email Writer',
      'icon': Icons.email,
      'variables': [
        {'key': 'purpose', 'label': 'Purpose', 'placeholder': 'e.g., Request a meeting'},
        {'key': 'tone', 'label': 'Tone', 'placeholder': 'e.g., Professional, Friendly'},
        {'key': 'audience', 'label': 'Audience', 'placeholder': 'e.g., Manager, Client'},
        {'key': 'key_points', 'label': 'Key Points', 'placeholder': 'e.g., Project update, Timeline'},
        {'key': 'cta', 'label': 'Call to Action', 'placeholder': 'e.g., Please reply by Friday'},
      ],
      'template': 'Write a {tone} email for the following purpose:\n\nPurpose: {purpose}\n\nTarget audience: {audience}\n\nKey points to include:\n{key_points}\n\nCall to action: {cta}\n\nPlease generate a professional email that is clear, concise, and effective.',
    },
    {
      'name': 'Code Generator',
      'icon': Icons.code,
      'variables': [
        {'key': 'language', 'label': 'Language', 'placeholder': 'e.g., Python, JavaScript'},
        {'key': 'task', 'label': 'Task', 'placeholder': 'e.g., Create a login function'},
        {'key': 'requirements', 'label': 'Requirements', 'placeholder': 'e.g., Input validation, Error handling'},
        {'key': 'complexity', 'label': 'Complexity', 'placeholder': 'e.g., Basic, Advanced'},
      ],
      'template': 'Generate {language} code for the following task:\n\nTask: {task}\n\nRequirements:\n- {requirements}\n\nComplexity level: {complexity}\n\nPlease provide well-commented, production-ready code with proper error handling.',
    },
    {
      'name': 'Blog Post',
      'icon': Icons.article,
      'variables': [
        {'key': 'topic', 'label': 'Topic', 'placeholder': 'e.g., Benefits of meditation'},
        {'keywords': 'keywords', 'label': 'Keywords', 'placeholder': 'e.g., meditation, mindfulness, health'},
        {'key': 'word_count', 'label': 'Word Count', 'placeholder': 'e.g., 1000'},
        {'key': 'tone', 'label': 'Tone', 'placeholder': 'e.g., Informative, Casual'},
      ],
      'template': 'Write a blog post about:\n\nTopic: {topic}\n\nTarget keywords: {keywords}\n\nWord count: {word_count} words\n\nTone: {tone}\n\nInclude an engaging introduction, well-structured body paragraphs, and a compelling conclusion.',
    },
    {
      'name': 'Image Prompt',
      'icon': Icons.image,
      'variables': [
        {'key': 'subject', 'label': 'Subject', 'placeholder': 'e.g., A serene mountain landscape'},
        {'key': 'style', 'label': 'Style', 'placeholder': 'e.g., Photorealistic, Oil painting'},
        {'key': 'lighting', 'label': 'Lighting', 'placeholder': 'e.g., Golden hour, Studio'},
        {'key': 'mood', 'label': 'Mood', 'placeholder': 'e.g., Peaceful, Dramatic'},
        {'key': 'details', 'label': 'Additional Details', 'placeholder': 'e.g., With birds in sky'},
      ],
      'template': 'Create an image generation prompt for:\n\nSubject: {subject}\n\nStyle: {style}\n\nLighting: {lighting}\n\nMood: {mood}\n\nAdditional details: {details}\n\nUse high quality, 8k resolution, detailed features, and professional composition.',
    },
    {
      'name': 'Video Script',
      'icon': Icons.videocam,
      'variables': [
        {'key': 'topic', 'label': 'Topic', 'placeholder': 'e.g., How to cook pasta'},
        {'key': 'duration', 'label': 'Duration', 'placeholder': 'e.g., 10 minutes'},
        {'key': 'tone', 'label': 'Tone', 'placeholder': 'e.g., Educational, Fun'},
        {'key': 'audience', 'label': 'Target Audience', 'placeholder': 'e.g., Beginners'},
      ],
      'template': 'Create a video script for:\n\nTopic: {topic}\n\nDuration: {duration}\n\nTone: {tone}\n\nTarget audience: {audience}\n\nInclude:\n- Hook (first 10 seconds)\n- Main content sections\n- Key points\n- Call to action\n- End screen suggestions',
    },
    {
      'name': 'Social Media',
      'icon': Icons.share,
      'variables': [
        {'key': 'platform', 'label': 'Platform', 'placeholder': 'e.g., Instagram, Twitter'},
        {'key': 'content_type', 'label': 'Content Type', 'placeholder': 'e.g., Post, Story, Reel'},
        {'key': 'topic', 'label': 'Topic', 'placeholder': 'e.g., New product launch'},
        {'key': 'hashtags', 'label': 'Hashtags', 'placeholder': 'e.g., #startup #tech'},
        {'key': 'cta', 'label': 'Call to Action', 'placeholder': 'e.g., Link in bio'},
      ],
      'template': 'Create a {platform} {content_type} about:\n\nTopic: {topic}\n\nInclude:\n- Catchy headline\n- Engaging content\n- Relevant hashtags: {hashtags}\n- Call to action: {cta}',
    },
    {
      'name': 'Data Analysis',
      'icon': Icons.analytics,
      'variables': [
        {'key': 'data_type', 'label': 'Data Type', 'placeholder': 'e.g., Sales data'},
        {'key': 'goal', 'label': 'Analysis Goal', 'placeholder': 'e.g., Find trends'},
        {'key': 'variables', 'label': 'Variables', 'placeholder': 'e.g., Revenue, Date'},
        {'key': 'format', 'label': 'Output Format', 'placeholder': 'e.g., Charts, Tables'},
      ],
      'template': 'Help analyze {data_type} for:\n\nGoal: {goal}\n\nVariables to analyze: {variables}\n\nDesired output: {format}\n\nProvide insights, trends, and actionable recommendations.',
    },
    {
      'name': 'Customer Support',
      'icon': Icons.support_agent,
      'variables': [
        {'key': 'issue_type', 'label': 'Issue Type', 'placeholder': 'e.g., Technical problem'},
        {'key': 'tone', 'label': 'Tone', 'placeholder': 'e.g., Empathetic, Professional'},
        {'key': 'product', 'label': 'Product', 'placeholder': 'e.g., Our app'},
        {'key': 'resolution', 'label': 'Resolution', 'placeholder': 'e.g., Step-by-step guide'},
      ],
      'template': 'Write a customer support response for:\n\nIssue: {issue_type}\n\nTone: {tone}\n\nProduct: {product}\n\nResolution: {resolution}\n\nInclude troubleshooting steps, empathy, and follow-up guidance.',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialTemplate != null) {
      _selectedTemplate = widget.initialTemplate!;
      _generatePrompt();
    }
  }

  @override
  void dispose() {
    for (var controller in _variableControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _selectTemplate(Map<String, dynamic> template) {
    setState(() {
      _selectedTemplate = template['name'];
      _variableControllers.clear();
      for (var variable in template['variables']) {
        _variableControllers[variable['key']] = TextEditingController();
      }
      _generatePrompt();
    });
  }

  void _generatePrompt() {
    if (_selectedTemplate.isEmpty) return;

    final template = _templates.firstWhere(
      (t) => t['name'] == _selectedTemplate,
      orElse: () => {},
    );

    if (template.isEmpty) return;

    String prompt = template['template'];
    
    for (var entry in _variableControllers.entries) {
      final value = entry.value.text.isEmpty ? '[${entry.key}]' : entry.value.text;
      prompt = prompt.replaceAll('{${entry.key}}', value);
    }

    setState(() {
      _generatedPrompt = prompt;
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedPrompt));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Copied to clipboard!'),
          ],
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final template = _selectedTemplate.isNotEmpty
        ? _templates.firstWhere(
            (t) => t['name'] == _selectedTemplate,
            orElse: () => {},
          )
        : {};

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Prompt Builder',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Template Selection
                  Text(
                    'Select Template',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _templates.length,
                      itemBuilder: (context, index) {
                        final t = _templates[index];
                        final isSelected = _selectedTemplate == t['name'];
                        return GestureDetector(
                          onTap: () => _selectTemplate(t),
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.2)
                                  : (isDark ? AppColors.surfaceContainerDark : AppColors.surfaceContainerLight),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  t['icon'],
                                  color: isSelected ? AppColors.primary : (isDark ? AppColors.mutedDark : AppColors.mutedLight),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  t['name'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? AppColors.primary : (isDark ? AppColors.foregroundDark : AppColors.foregroundLight),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  if (_selectedTemplate.isNotEmpty) ...[
                    const SizedBox(height: 24),

                    // Variables
                    Text(
                      'Fill Variables',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...template['variables'].map<Widget>((variable) {
                      _variableControllers[variable['key']] ??= TextEditingController();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextField(
                          controller: _variableControllers[variable['key']],
                          decoration: InputDecoration(
                            labelText: variable['label'],
                            hintText: variable['placeholder'],
                          ),
                          onChanged: (_) => _generatePrompt(),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 24),

                    // Preview
                    Text(
                      'Preview',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceContainerDark : AppColors.surfaceContainerLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: SelectableText(
                        _generatedPrompt.isEmpty ? 'Fill in the variables to see preview...' : _generatedPrompt,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13,
                          color: _generatedPrompt.isEmpty
                              ? (isDark ? AppColors.mutedDark : AppColors.mutedLight)
                              : (isDark ? AppColors.foregroundDark : AppColors.foregroundLight),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Action Buttons
          if (_selectedTemplate.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _generatedPrompt.isEmpty ? null : _copyToClipboard,
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy & Use'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
