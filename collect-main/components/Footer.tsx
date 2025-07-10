import React from 'react';
import {
  View,
  Text,
  Image,
  StyleSheet,
  Dimensions,
  PixelRatio,
  Platform,
  ImageBackground,
} from 'react-native';

const { width } = Dimensions.get('window');
const scale = PixelRatio.getFontScale();

export default function Footer() {
  return (
    <ImageBackground
      source={require('../assets/images/wallpaper_green.jpg')}
      style={styles.background}
      resizeMode="cover"
    >
      <View style={styles.footer}>
        <Image
          source={require('../assets/images/settings_icon.png')}
          style={styles.footerIcon}
          accessibilityLabel="Settings icon"
        />
        <Image
          source={require('../assets/images/globo.png')}
          style={styles.footerIcon}
          accessibilityLabel="Globe icon"
        />
        <Text style={styles.versionText} accessible accessibilityLabel="Beta version 0.0.1">
          Beta Version 0.0.1
        </Text>
      </View>
    </ImageBackground>
  );
}

const styles = StyleSheet.create({
  background: {
    width: '100%', // Full width to stretch across the screen
    backgroundColor: '#1C2526', // Match parent background to avoid gaps
    paddingVertical: 15, // Adjusted for better spacing
  },
  footer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between', // Distribute items evenly
    width: '90%',
    paddingHorizontal: 20,
    paddingVertical: 10,
    alignSelf: 'center', // Center the footer content
  },
  footerIcon: {
    width: width * 0.08,
    height: width * 0.08,
    maxWidth: 40,
    maxHeight: 40,
    tintColor: '#fff', // Ensure icons are white to match the screenshot
  },
  versionText: {
    color: '#fff',
    fontSize: 12 * scale,
  },
});