"""Unit tests for the Emotion Detection application."""
import unittest
from EmotionDetection.emotion_detection import emotion_detector

class TestEmotionDetection(unittest.TestCase):
    """Test cases for emotion_detector function."""

    def test_emotion_detector(self):
        """Test dominant emotions for various input statements."""
        # Statement 1: Joy
        res_joy = emotion_detector("I am glad this happened")
        self.assertEqual(res_joy['dominant_emotion'], 'joy')

        # Statement 2: Anger
        res_anger = emotion_detector("I am really mad about this")
        self.assertEqual(res_anger['dominant_emotion'], 'anger')

        # Statement 3: Disgust
        res_disgust = emotion_detector("I feel disgusted just hearing about this")
        self.assertEqual(res_disgust['dominant_emotion'], 'disgust')

        # Statement 4: Sadness
        res_sadness = emotion_detector("I am so sad about this")
        self.assertEqual(res_sadness['dominant_emotion'], 'sadness')

        # Statement 5: Fear
        res_fear = emotion_detector("I am really afraid that this will happen")
        self.assertEqual(res_fear['dominant_emotion'], 'fear')

if __name__ == '__main__':
    unittest.main()
