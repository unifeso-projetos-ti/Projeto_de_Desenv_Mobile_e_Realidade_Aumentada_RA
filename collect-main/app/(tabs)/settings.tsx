import React, { useState } from 'react';
import {
  View,
  Text,
  Image,
  TouchableOpacity,
  StyleSheet,
  SafeAreaView,
  Dimensions,
  PixelRatio,
  Platform,
} from 'react-native';
import Slider from '@react-native-community/slider';
import { Link } from 'expo-router';

const { width, height } = Dimensions.get('window');
const scale = PixelRatio.getFontScale();

export default function SettingsScreen() {
  const [musicValue, setMusicValue] = useState(50);
  const [soundValue, setSoundValue] = useState(50);
  const [vibration, setVibration] = useState(false);
  const [batterySaver, setBatterySaver] = useState(true);

  const handleBackPress = () => {
    // Navigation logic to go back (e.g., using React Navigation)
    console.log('Back pressed');
  };

  return (
    <SafeAreaView style={styles.container}>
      {/* Removed ImageBackground for solid dark theme */}
      <View style={styles.content}>
        {/* Header with Back Arrow and Logo */}
        <View style={styles.header}>
        <Link href="/home" >
          <TouchableOpacity
            onPress={handleBackPress}
            accessible
            accessibilityLabel="Go back"
          >
            <Image
              source={require('../../assets/icons/back_arrow.png')}
              style={styles.backArrow}
              accessibilityLabel="Back arrow"
            />
          </TouchableOpacity>
          </Link>
          <Image
            source={require('../../assets/images/ai_logo.png')}
            style={styles.logo}
            accessibilityLabel="Brainiax logo"
          />
        </View>

        {/* Settings Title */}
        <Text style={styles.title} accessible accessibilityLabel="Settings title">
          SETTINGS
        </Text>

        {/* Settings Items */}
        <View style={styles.settingsContainer}>
          <SettingsItem icon={require('../../assets/icons/profile.png')} label="ACCOUNT" />
          <SettingsItem icon={require('../../assets/icons/settings.png')} label="GENERAL" />
          <SettingsItem icon={require('../../assets/icons/notifications_icon.png')} label="NOTIFICATIONS" />
          <SettingsItem icon={require('../../assets/icons/guide_icon.png')} label="GUIDE" />

          {/* Music Slider */}
          <View style={styles.sliderItem}>
            <Image source={require('../../assets/icons/sound_icon.png')} style={styles.icon} />
            <View style={styles.sliderContent}>
              <Text style={styles.label}>MUSIC</Text>
              <Slider
                style={styles.slider}
                minimumValue={0}
                maximumValue={100}
                value={musicValue}
                onValueChange={setMusicValue}
                minimumTrackTintColor="#fff"
                maximumTrackTintColor="#555"
                thumbTintColor="#fff"
                accessibilityLabel="Music volume slider"
              />
            </View>
          </View>

          {/* Sound Slider */}
          <View style={styles.sliderItem}>
            <Image source={require('../../assets/icons/sound_icon.png')} style={styles.icon} />
            <View style={styles.sliderContent}>
              <Text style={styles.label}>SOUND</Text>
              <Slider
                style={styles.slider}
                minimumValue={0}
                maximumValue={100}
                value={soundValue}
                onValueChange={setSoundValue}
                minimumTrackTintColor="#fff"
                maximumTrackTintColor="#555"
                thumbTintColor="#fff"
                accessibilityLabel="Sound volume slider"
              />
            </View>
          </View>

          {/* Vibration Checkbox */}
          <View style={styles.checkboxItem}>
            <Text style={styles.label}>VIBRATION</Text>
            <TouchableOpacity
              onPress={() => setVibration(!vibration)}
              accessible
              accessibilityLabel="Toggle vibration"
            >
              <View style={[styles.checkbox, vibration && styles.checkboxChecked]}>
                {vibration && <Text style={styles.checkmark}>✔</Text>}
              </View>
            </TouchableOpacity>
          </View>

          {/* Battery Saver Checkbox */}
          <View style={styles.checkboxItem}>
            <Text style={styles.label}>BATTERY SAVER</Text>
            <TouchableOpacity
              onPress={() => setBatterySaver(!batterySaver)}
              accessible
              accessibilityLabel="Toggle battery saver"
            >
              <View style={[styles.checkbox, batterySaver && styles.checkboxChecked]}>
                {batterySaver && <Text style={styles.checkmark}>✔</Text>}
              </View>
            </TouchableOpacity>
          </View>

          {/* Help Center Links */}
          <TouchableOpacity accessible accessibilityLabel="Help Center">
            <Text style={styles.link}>HELP CENTER</Text>
          </TouchableOpacity>
          <TouchableOpacity accessible accessibilityLabel="About Brainiax">
            <Text style={styles.link}>ABOUT BRAINIAX</Text>
          </TouchableOpacity>
          <TouchableOpacity accessible accessibilityLabel="Help Center">
            <Text style={styles.link}>HELP CENTER</Text>
          </TouchableOpacity>
        </View>

        {/* Footer Version Text */}
        <Text style={styles.versionText} accessible accessibilityLabel="Beta version 0.0.1">
          Beta Version 0.0.1
        </Text>
      </View>
    </SafeAreaView>
  );
}

interface SettingsItemProps {
  icon: any;
  label: string;
}

function SettingsItem({ icon, label }: SettingsItemProps) {
  return (
    <TouchableOpacity style={styles.settingsItem} accessible accessibilityLabel={label}>
      <Image source={icon} style={styles.icon} />
      <Text style={styles.label}>{label}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'black', // Dark theme base color
    paddingTop: Platform.OS === 'ios' ? 20 : 0,
    justifyContent:'center'
  },
  content: {
    flex: 1,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: width * 0.04,
    paddingVertical: height * 0.02 * scale, // Responsive padding
  },
  backArrow: {
    width: width * 0.06,
    height: width * 0.06,
    maxWidth: 30 * scale,
    maxHeight: 30 * scale,
  },
  logo: {
    width: width * 0.15,
    height: width * 0.15,
    maxWidth: 60 * scale,
    maxHeight: 60 * scale,
  },
  title: {
    color: '#fff',
    fontSize: 20 * scale,
    fontWeight: 'bold',
    textAlign: 'center',
    marginVertical: height * 0.02 * scale,
    borderBottomWidth: 1,
    borderBottomColor: '#fff',
    paddingBottom: height * 0.01 * scale,
    textTransform: 'uppercase',
  },
  settingsContainer: {
    flex: 1,
    paddingHorizontal: width * 0.06,
    paddingVertical: height * 0.02 * scale,
    backgroundColor: 'rgba(128, 128, 128, 0.5)', // Semi-transparent gray for Apple-like effect
    borderRadius: 20,
    marginHorizontal: width * 0.03,
    marginTop: height * 0.02 * scale,
    maxWidth: width * 0.9, // Limit max width for responsiveness
  },
  settingsItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: height * 0.03 * scale,
    paddingVertical: height * 0.01 * scale,
  },
  sliderItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: height * 0.03 * scale,
    paddingVertical: height * 0.01 * scale,
  },
  sliderContent: {
    flex: 1,
    marginLeft: width * 0.04,
  },
  slider: {
    width: '100%',
    height: 40 * scale, // Responsive slider height
  },
  checkboxItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: height * 0.03 * scale,
    paddingVertical: height * 0.01 * scale,
  },
  checkbox: {
    width: width * 0.06,
    height: width * 0.06,
    maxWidth: 24 * scale,
    maxHeight: 24 * scale,
    borderWidth: 2,
    borderColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'transparent',
  },
  checkboxChecked: {
    backgroundColor: '#fff',
  },
  checkmark: {
    color: '#1C2526', // Match dark theme
    fontSize: 16 * scale,
  },
  icon: {
    width: width * 0.06,
    height: width * 0.06,
    maxWidth: 24 * scale,
    maxHeight: 24 * scale,
    marginRight: width * 0.04,
    tintColor: '#fff',
  },
  label: {
    color: '#fff',
    fontSize: 16 * scale,
    fontWeight: '500',
  },
  link: {
    color: '#fff',
    fontSize: 16 * scale,
    fontWeight: '500',
    marginBottom: height * 0.02 * scale,
  },
  versionText: {
    color: '#fff',
    fontSize: 12 * scale,
    textAlign: 'center',
    marginBottom: height * 0.03 * scale,
    marginTop: height * 0.02 * scale,
  },
});