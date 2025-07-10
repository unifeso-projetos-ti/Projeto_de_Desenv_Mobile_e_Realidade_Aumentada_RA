import React, { useState } from "react";
import {
  View,
  Text,
  Modal,
  TouchableOpacity,
  StyleSheet,
  SafeAreaView,
  Dimensions,
  PixelRatio,
  Platform,
  FlatList,
} from "react-native";
import Header from "../../components/Header";
import Footer from "../../components/Footer";
import Constants from "expo-constants";
import ThreeDModelView from "@/components/ThreeDModelView";
import ARModelView from "@/components/ARModelView";

// Importa o mock dos modelos
import modelsMock from "@/assets/models/models-mockdb";

const { width, height } = Dimensions.get("window");
const scale = PixelRatio.getFontScale();

export default function App() {
  const [isAR, setIsAR] = useState(false);
  const [modalVisible, setModalVisible] = useState(false);
  const [selectedModel, setSelectedModel] = useState(modelsMock[0]);
  const isRunningInExpo = Constants.executionEnvironment;

  const onSelectModel = (model: typeof modelsMock[0]) => {
    setSelectedModel(model);
    setModalVisible(false);
  };
  
  return (
    <SafeAreaView style={styles.container}>
      <Header isAR={isAR} onToggleAR={setIsAR} />

      <View style={styles.content}>
        <Text style={styles.title}>{selectedModel.name}</Text>

        {isAR ? (
          isRunningInExpo ? (
            <View style={styles.expoMessage}>
              <Text style={styles.expoTitle}>AR Real</Text>
              <Text style={styles.expoText}>
                Para experimentar AR real, instale o aplicativo em seu dispositivo.
              </Text>
              <Text style={styles.expoSubtext}>
                O AR real requer acesso à câmera e sensores do dispositivo.
              </Text>
            </View>
          ) : (
            <ARModelView modelUrl={selectedModel.url} />
          )
        ) : (
          <ThreeDModelView modelUrl={selectedModel.url} />
        )}

        <TouchableOpacity
          style={styles.button}
          onPress={() => setModalVisible(true)}
          accessibilityRole="button"
          accessibilityLabel="Change model"
        >
          <Text style={styles.buttonText}>Change</Text>
        </TouchableOpacity>
      </View>

      <Footer />

      {/* Modal */}
      <Modal
        animationType="slide"
        transparent={true}
        visible={modalVisible}
        onRequestClose={() => setModalVisible(false)}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <Text style={styles.modalText}>Selecione um novo modelo</Text>

            <FlatList
              data={modelsMock}
              keyExtractor={(item) => item.slug}
              renderItem={({ item }) => (
                <TouchableOpacity
                  style={styles.modelOption}
                  onPress={() => onSelectModel(item)}
                >
                  <Text style={styles.modelOptionText}>{item.name}</Text>
                </TouchableOpacity>
              )}
            />

            <TouchableOpacity
              style={[styles.button, { borderTopColor: "#ccc", marginTop: 10 }]}
              onPress={() => setModalVisible(false)}
            >
              <Text style={styles.buttonText}>Fechar</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#000",
    paddingTop: Platform.OS === "ios" ? 20 : 0,
  },
  content: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    paddingHorizontal: width * 0.05,
  },
  title: {
    color: "#fff",
    fontSize: 16 * scale,
    fontWeight: "600",
    marginBottom: height * 0.02,
    textAlign: "center",
  },
  button: {
    borderTopWidth: 2,
    borderTopColor: "#fff",
    paddingHorizontal: width * 0.1,
    paddingVertical: height * 0.015,
    alignItems: "center",
    minWidth: width * 0.2,
  },
  buttonText: {
    color: "#fff",
    fontSize: 14 * scale,
    fontWeight: "500",
  },
  expoMessage: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    paddingHorizontal: 20,
    backgroundColor: "rgba(0, 0, 0, 0.8)",
    borderRadius: 10,
    margin: 20,
  },
  expoTitle: {
    color: "#00ff00",
    fontSize: 18,
    fontWeight: "bold",
    marginBottom: 10,
  },
  expoText: {
    color: "#fff",
    fontSize: 14,
    textAlign: "center",
    marginBottom: 8,
  },
  expoSubtext: {
    color: "#ccc",
    fontSize: 12,
    textAlign: "center",
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.5)",
    justifyContent: "center",
    alignItems: "center",
  },
  modalContent: {
    width: width * 0.8,
    backgroundColor: "#111",
    padding: 20,
    borderRadius: 10,
    alignItems: "center",
  },
  modalText: {
    color: "#fff",
    fontSize: 16 * scale,
    marginBottom: 20,
  },
  modelOption: {
    paddingVertical: 12,
    width: "100%",
    borderBottomWidth: 1,
    borderBottomColor: "#444",
  },
  modelOptionText: {
    color: "#fff",
    fontSize: 14 * scale,
    textAlign: "center",
  },
});
