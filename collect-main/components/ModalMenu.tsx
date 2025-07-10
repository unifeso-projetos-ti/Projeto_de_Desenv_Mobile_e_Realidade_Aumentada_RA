import { Link } from 'expo-router';
import React from 'react';
import {
  View,
  Text,
  Modal,
  TouchableOpacity,
  Image,
  StyleSheet,
  Dimensions,
  PixelRatio,
} from 'react-native';

const { width, height } = Dimensions.get('window');
const scale = PixelRatio.getFontScale();

interface ModalMenuProps {
  visible: boolean;
  onClose: () => void;
}

export default function ModalMenu({ visible, onClose }: ModalMenuProps) {
  return (
    <Modal animationType="slide" transparent visible={visible}>
      <View style={styles.overlay}>
        <TouchableOpacity
          style={styles.closeArea}
          onPress={onClose}
          accessible
          accessibilityLabel="Close menu"
        />
        <View style={styles.menu}>
          <View style={styles.header}>
            <Image
              source={require('../assets/images/ai_logo.png')}
              style={styles.logo}
              accessibilityLabel="Brainiax logo"
            />
            <Text style={styles.title}>BRAINIAX</Text>
          </View>
          <View style={styles.items}>
            <MenuItem icon={require('../assets/icons/profile.png')} label="PROFILE" />
            <Link href="/settings" >
              <MenuItem icon={require('../assets/icons/settings.png')} label="SETTINGS" />
            </Link>
            <MenuItem icon={require('../assets/icons/friends.png')} label="FRIENDS" />
            <MenuItem icon={require('../assets/icons/trophy.png')} label="ACHIEVEMENT" />
            <MenuItem icon={require('../assets/icons/exit.png')} label="EXIT" />
          </View>
        </View>
      </View>
    </Modal>
  );
}

interface MenuItemProps {
  icon: any;
  label: string;
}

function MenuItem({ icon, label }: MenuItemProps) {
  return (
    <TouchableOpacity style={styles.menuItem} accessible accessibilityLabel={label}>
      <Image source={icon} style={styles.icon} />
      <Text style={styles.label}>{label}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  overlay: {
    flex: 1,
    flexDirection: 'row',
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  closeArea: {
    flex: 1,
  },
  menu: {
    width: Math.min(width * 0.7, 400),
    backgroundColor: 'rgb(0, 33, 0)',
    paddingTop: height * 0.05,
    paddingHorizontal: width * 0.04,
    borderTopLeftRadius: 20,
    borderBottomLeftRadius: 20,
  },
  header: {
    alignItems: 'center',
    marginBottom: height * 0.03,
  },
  logo: {
    width: width * 0.15,
    height: width * 0.15,
    maxWidth: 60,
    maxHeight: 60,
    marginBottom: height * 0.01,
  },
  title: {
    color: '#fff',
    fontSize: 18 * scale,
    fontWeight: 'bold',
  },
  items: {
    gap: height * 0.02,
  },
  menuItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: height * 0.01,
  },
  icon: {
    width: width * 0.06,
    height: width * 0.06,
    maxWidth: 24,
    maxHeight: 24,
    marginRight: width * 0.03,
  },
  label: {
    color: '#fff',
    fontSize: 16 * scale,
    fontWeight: '500',
  },
});