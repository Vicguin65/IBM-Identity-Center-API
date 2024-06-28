import matplotlib.pyplot as plt
import numpy as np

# Data from the National Academies Press report on polygraph accuracy
accuracy_values = np.array([0.70, 0.75, 0.80, 0.85, 0.90, 0.95])
interquartile_range = (0.81, 0.91)
mean_accuracy = np.mean(accuracy_values)
std_accuracy = np.std(accuracy_values)

# Data for ERNN model performance from Springer
model_names = ['ERNN', 'ANN', 'RNN', 'LSTM']
accuracy_scores = [97.3, 95.4, 96.4, 96.9]
precision_scores = [97.9, 94.7, 96.4, 97.0]
recall_scores = [98.1, 95.2, 97.1, 97.5]
f1_scores = [97.77, 94.56, 96.6, 96.63]

# Redefine the color scheme
colors = {
    'accuracy': '#000000',   # black
    'precision': '#D2B48C',  # beige
    'recall': '#A9A9A9',     # dark gray
    'f1-score': '#808080'    # gray
}

plt.figure(figsize=(14, 6))

# Plotting the National Academies Press data with grey bars and black error bars
plt.subplot(1, 2, 1)
plt.bar(['Q1', 'Median', 'Q3'], interquartile_range + (mean_accuracy,), color='gray')
plt.errorbar(['Q1', 'Median', 'Q3'], interquartile_range + (mean_accuracy,), yerr=std_accuracy, fmt='o', color='black')
plt.ylim(0, 1)
plt.title('Polygraph Accuracy Interquartile Range')
plt.xlabel('Statistic')
plt.ylabel('Accuracy')
plt.grid(True)

# Plotting the ERNN model performance data
x = np.arange(len(model_names))

plt.subplot(1, 2, 2)
plt.bar(x - 0.3, accuracy_scores, width=0.2, color=colors['accuracy'], label='Accuracy')
plt.bar(x - 0.1, precision_scores, width=0.2, color=colors['precision'], label='Precision')
plt.bar(x + 0.1, recall_scores, width=0.2, color=colors['recall'], label='Recall')
plt.bar(x + 0.3, f1_scores, width=0.2, color=colors['f1-score'], label='F1-score')
plt.xticks(x, model_names)
plt.ylim(90, 100)
plt.title('Performance of Neural Network Models in Lie Detection')
plt.xlabel('Model')
plt.ylabel('Percentage')
plt.legend()
plt.grid(True)

plt.tight_layout()
plt.show()
