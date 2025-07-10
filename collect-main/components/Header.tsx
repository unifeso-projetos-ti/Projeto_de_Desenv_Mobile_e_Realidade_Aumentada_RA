// components/Header.tsx
import React, { useState } from 'react';
import { View, Text, Image, Switch, TouchableOpacity, StyleSheet } from 'react-native';
import ModalMenu from './ModalMenu';

interface HeaderProps {
  isAR: boolean;
  onToggleAR: (value: boolean) => void;
}

export default function Header({ isAR, onToggleAR }: HeaderProps) {
  const [menuVisible, setMenuVisible] = useState(false);

  return (
    <>
      <View style={styles.topBar}>
        <TouchableOpacity onPress={() => {setMenuVisible(true);console.log(menuVisible)}}>
          <Image source={require('../assets/images/ai_logo.png')} style={styles.iconTopLeft} />
        </TouchableOpacity>

        <View style={styles.profileArea}>
          <Text style={styles.profileText}>PROFILE</Text>
          <Image source={require('../assets/images/profile_icon.png')} style={styles.profileIcon} />
          <Text style={styles.profileText}>AR</Text>
          <Switch
            value={isAR}
            onValueChange={onToggleAR}
            thumbColor={isAR ? '#ffffff' : '#999'}
            trackColor={{ false: '#555', true: '#666' }}
          />
        </View>
      </View>

      <ModalMenu visible={menuVisible} onClose={() => setMenuVisible(false)} />
    </>
  );
}

const styles = StyleSheet.create({
  topBar: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    margin: 16,
    alignItems: 'center'
  },
  iconTopLeft: { width: 80, height: 60 },
  profileArea: { flexDirection: 'row', alignItems: 'center' },
  profileText: { color: '#fff', marginRight: 8 },
  profileIcon: { width: 30, height: 30, marginRight: 8 }
});
