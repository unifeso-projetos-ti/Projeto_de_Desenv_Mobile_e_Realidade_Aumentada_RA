import flet as ft
import cv2
import base64
import threading
import time
import numpy as np
import mediapipe as mp
import json
import os
import random

def overlay_with_alpha(background_img, overlay_img, x, y):
    h_overlay, w_overlay, _ = overlay_img.shape
    h_bg, w_bg, _ = background_img.shape
    x, y = int(x), int(y)
    y1, y2 = max(0, y), min(y + h_overlay, h_bg)
    x1, x2 = max(0, x), min(x + w_overlay, w_bg)
    roi_bg = background_img[y1:y2, x1:x2]
    roi_h, roi_w = roi_bg.shape[:2]
    if roi_h > 0 and roi_w > 0:
        overlay_cropped = overlay_img[:roi_h, :roi_w]
        alpha = overlay_cropped[:, :, 3] / 255.0
        overlay_rgb = overlay_cropped[:, :, :3]
        for c in range(0, 3):
            roi_bg[:, :, c] = (overlay_rgb[:, :, c] * alpha) + (roi_bg[:, :, c] * (1.0 - alpha))
    return background_img

class CameraApp:
    def __init__(self, page: ft.Page):
        self.page = page
        self.is_running = False
        self.camera_thread = None
        self.overlay_png = None
        self.mp_hands = mp.solutions.hands
        self.hands = self.mp_hands.Hands(min_detection_confidence=0.7, min_tracking_confidence=0.5)
        placeholder_pixel = np.zeros((1, 1, 4), dtype=np.uint8)
        _, buffer = cv2.imencode('.png', placeholder_pixel)
        b64_string_placeholder = base64.b64encode(buffer).decode('utf-8')
        self.camera_image = ft.Image(src_base64=b64_string_placeholder, fit=ft.ImageFit.CONTAIN, expand=True, border_radius=ft.border_radius.all(10))
        self.stack = ft.Stack(controls=[self.camera_image])
    
    def set_overlay_image(self, image_filename):
        try:
            path = f'assets/{image_filename}'
            self.overlay_png = cv2.imread(path, cv2.IMREAD_UNCHANGED)
            if self.overlay_png is None or self.overlay_png.shape[2] != 4:
                raise ValueError(f"Imagem '{image_filename}' não encontrada ou sem transparência.")
            return True
        except Exception as e:
            print(f"Erro ao carregar a imagem de overlay: {e}")
            self.overlay_png = None
            return False

    def start(self):
        if self.is_running or self.overlay_png is None: return
        self.cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)
        if not self.cap.isOpened():
            print("Erro: Não foi possível abrir a câmera.")
            return
        self.is_running = True
        self.camera_thread = threading.Thread(target=self.update_camera_thread, daemon=True)
        self.camera_thread.start()

    def stop(self):
        if not self.is_running: return
        self.is_running = False
        if self.camera_thread: self.camera_thread.join()
        if hasattr(self, 'cap') and self.cap.isOpened(): self.cap.release()
        print("Câmera e recursos de AR liberados.")

    def update_camera_thread(self):
        while self.is_running:
            try:
                ret, frame = self.cap.read()
                if not ret: break
                frame = cv2.flip(frame, 1)
                frame_h, frame_w, _ = frame.shape
                rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                results = self.hands.process(rgb_frame)
                if results.multi_hand_landmarks:
                    for hand_landmarks in results.multi_hand_landmarks:
                        wrist = hand_landmarks.landmark[self.mp_hands.HandLandmark.WRIST]
                        middle_finger_mcp = hand_landmarks.landmark[self.mp_hands.HandLandmark.MIDDLE_FINGER_MCP]
                        center_x = int(((wrist.x + middle_finger_mcp.x) / 2) * frame_w)
                        center_y = int(((wrist.y + middle_finger_mcp.y) / 2) * frame_h)
                        overlay_w = 150
                        overlay_h = int(overlay_w * (self.overlay_png.shape[0] / self.overlay_png.shape[1]))
                        resized_overlay = cv2.resize(self.overlay_png, (overlay_w, overlay_h))
                        draw_x = center_x - (overlay_w // 2)
                        draw_y = center_y - (overlay_h // 2)
                        frame = overlay_with_alpha(frame, resized_overlay, draw_x, draw_y)
                _, buffer = cv2.imencode('.jpg', frame)
                b64_string = base64.b64encode(buffer).decode('utf-8')
                self.camera_image.src_base64 = b64_string
                self.page.update()
                time.sleep(1/60)
            except Exception as e:
                print(f"Erro no loop da câmera: {e}")

class QuizManager:
    
    def __init__(self, page, ar_app):
        self.page = page
        self.ar_app = ar_app
        self.scores_file = "scores.json"
        
        self.full_quiz_data = [
            {"question": "Qual é o principal dispositivo para clicar e mover o cursor na tela?", "options": ["Mouse", "Teclado", "Impressora", "Monitor"], "correct_answer": "Mouse", "reward_image": "mouse.png", "difficulty": "facil"},
            {"question": "Qual componente é o 'cérebro' do computador?", "options": ["Processador (CPU)", "Placa de Som", "Memória RAM", "Gabinete"], "correct_answer": "Processador (CPU)", "reward_image": "processor.png", "difficulty": "facil"},
            {"question": "Qual peça é a principal responsável por exibir os gráficos de um jogo?", "options": ["Placa de Vídeo (GPU)", "SSD", "Fonte de Alimentação", "Cooler"], "correct_answer": "Placa de Vídeo (GPU)", "reward_image": "gpu.png", "difficulty": "facil"},
            {"question": "Qual dispositivo de entrada é usado para digitar textos e comandos?", "options": ["Teclado", "Mouse", "Microfone", "Scanner"], "correct_answer": "Teclado", "reward_image": "keyboard.png", "difficulty": "facil"},
            {"question": "Se o PC fica lento com muitas abas abertas, qual tipo de memória está sobrecarregada?", "options": ["Memória RAM", "Memória Cache", "Memória ROM", "Armazenamento do HD"], "correct_answer": "Memória RAM", "reward_image": "ram.png", "difficulty": "medio"},
            {"question": "Para acelerar o tempo de boot e o carregamento de programas, qual upgrade é mais eficaz?", "options": ["Trocar o HDD por um SSD", "Aumentar a Memória RAM", "Comprar um Monitor Maior", "Instalar mais Coolers"], "correct_answer": "Trocar o HDD por um SSD", "reward_image": "ssd.png", "difficulty": "medio"},
            {"question": "Onde todos os componentes principais de um desktop são fisicamente conectados?", "options": ["Placa-Mãe", "Processador (CPU)", "Gabinete", "Disco Rígido (HD)"], "correct_answer": "Placa-Mãe", "reward_image": "computer.png", "difficulty": "medio"},
            {"question": "Qual componente converte a energia da tomada para alimentar o seu PC?", "options": ["Fonte de Alimentação", "Estabilizador", "Placa de Rede", "Bateria"], "correct_answer": "Fonte de Alimentação", "reward_image": "fonte.png", "difficulty": "medio"},
            {"question": "A velocidade de um processador em Gigahertz (GHz) representa fundamentalmente o quê?", "options": ["Ciclos por segundo", "Bytes por segundo", "Cálculos por ciclo", "Temperatura máxima"], "correct_answer": "Ciclos por segundo", "reward_image": "processor.png", "difficulty": "dificil"},
            {"question": "Qual é o nome do dispositivo de armazenamento magnético e rotativo, mais antigo que o SSD?", "options": ["Disco Rígido (HDD)", "Disquete", "Fita Cassete", "CD-R"], "correct_answer": "Disco Rígido (HDD)", "reward_image": "hd.png", "difficulty": "dificil"},
            {"question": "Qual protocolo de rede é mais comumente usado para obter um endereço IP automaticamente?", "options": ["DHCP", "HTTP", "FTP", "DNS"], "correct_answer": "DHCP", "reward_image": "ethernet.png", "difficulty": "dificil"},
            {"question": "Em uma placa de vídeo, o que a sigla 'VRAM' significa?", "options": ["Video Random Access Memory", "Virtual Reality Asset Module", "Volatile Read-Only Memory", "Very Rapid Access Memory"], "correct_answer": "Video Random Access Memory", "reward_image": "gpu.png", "difficulty": "dificil"},
        ]
        self.reset_game_state()

        
        self.high_score_text = ft.Text(italic=True, color=ft.Colors.WHITE70)
        self.high_score_container = ft.Container(
            self.high_score_text, top=10, right=10, padding=8,
            bgcolor=ft.Colors.BLACK26, border_radius=8, visible=True
        )

        
        self.username_field = ft.TextField(
            label="Digite seu nick", width=300, text_align=ft.TextAlign.CENTER,
            on_submit=self.show_difficulty_selection, label_style=ft.TextStyle(color=ft.Colors.WHITE70),
            text_style=ft.TextStyle(color=ft.Colors.WHITE), border_color=ft.Colors.WHITE54,
            focused_border_color=ft.Colors.WHITE, cursor_color=ft.Colors.WHITE
        )
        self.login_view = ft.Column(
            [
                ft.Text(" Tech Trívia Challenge 😎", size=30, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                self.username_field,
                ft.ElevatedButton("Próximo", on_click=self.show_difficulty_selection,
                                 bgcolor=ft.Colors.ORANGE, color=ft.Colors.WHITE)
            ],
            alignment=ft.MainAxisAlignment.CENTER, horizontal_alignment=ft.CrossAxisAlignment.CENTER, spacing=20,
            visible=True
        )

        
        self.difficulty_view = ft.Column(
            [
                ft.Text("Escolha a Dificuldade", size=32, color=ft.Colors.WHITE),
                ft.ElevatedButton("Fácil", on_click=self.select_difficulty, data="facil", width=200,
                                 icon=ft.Icons.CHILD_CARE, bgcolor=ft.Colors.GREEN, color=ft.Colors.WHITE),
                ft.ElevatedButton("Médio", on_click=self.select_difficulty, data="medio", width=200,
                                 icon=ft.Icons.SCHOOL, bgcolor=ft.Colors.LIGHT_BLUE_500, color=ft.Colors.WHITE),
                ft.ElevatedButton("Difícil", on_click=self.select_difficulty, data="dificil", width=200,
                                 icon=ft.Icons.BOLT, bgcolor=ft.Colors.RED, color=ft.Colors.WHITE),
            ],
            alignment=ft.MainAxisAlignment.CENTER, horizontal_alignment=ft.CrossAxisAlignment.CENTER,
            spacing=15, visible=False
        )
        
        self.username_display = ft.Text(weight=ft.FontWeight.BOLD, size=16, color=ft.Colors.WHITE70)
        self.lives_text = ft.Text(size=24)
        self.score_text = ft.Text(size=18, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE)
        self.question_text = ft.Text(size=22, weight=ft.FontWeight.BOLD, text_align=ft.TextAlign.CENTER, color=ft.Colors.WHITE)
        
        answer_button_style = ft.ButtonStyle(
            color=ft.Colors.WHITE, bgcolor=ft.Colors.WHITE24,
            shape=ft.RoundedRectangleBorder(radius=8),
        )
        self.answer_buttons = [ft.ElevatedButton(text=f"Opção {i+1}", width=300, style=answer_button_style) for i in range(4)]
        
        top_bar = ft.Row([ft.Column([self.username_display, self.lives_text]), self.score_text], alignment=ft.MainAxisAlignment.SPACE_BETWEEN)
        self.quiz_view = ft.Column(
            [top_bar, self.question_text, ft.Column(self.answer_buttons, spacing=5, horizontal_alignment=ft.CrossAxisAlignment.STRETCH)],
            alignment=ft.MainAxisAlignment.SPACE_AROUND, horizontal_alignment=ft.CrossAxisAlignment.CENTER, visible=False, expand=True
        )
        
        self.next_question_button = ft.ElevatedButton("Próxima Pergunta", icon=ft.Icons.ARROW_FORWARD, on_click=self.next_question)
        self.ar_view_container = ft.Stack([self.ar_app.stack, ft.Container(content=self.next_question_button, alignment=ft.alignment.bottom_center, padding=20)], expand=True, visible=False)
        self.final_message = ft.Text(size=32)
        self.final_score_text = ft.Text(size=28, text_align=ft.TextAlign.CENTER, color=ft.Colors.BLUE_GREY_700)
        self.play_again_button = ft.ElevatedButton("Jogar Novamente", on_click=self.reset_quiz)
        self.final_view = ft.Column([self.final_message, self.final_score_text, self.play_again_button], horizontal_alignment=ft.CrossAxisAlignment.CENTER, spacing=20, visible=False)
        
        self.load_and_display_high_score()

    def load_scores(self):
        if not os.path.exists(self.scores_file): return []
        with open(self.scores_file, 'r') as f:
            try: return json.load(f)
            except json.JSONDecodeError: return []

    def is_username_taken(self, username):
        scores = self.load_scores()
        return any(score['username'].lower() == username.lower() for score in scores)

    def load_and_display_high_score(self):
        scores = self.load_scores()
        if scores: self.high_score_text.value = f"🏆 Recorde: {scores[0]['username']} - {scores[0]['score']} pts"
        else: self.high_score_text.value = "Seja o primeiro a marcar pontos!"
        if self.login_view.visible: self.page.update()
    
    def reset_game_state(self):
        self.username = ""; self.score = 0; self.lives = 3; self.current_question_index = 0
        self.selected_difficulty = None; self.current_quiz_questions = []

    def show_difficulty_selection(self, e):
        username = self.username_field.value.strip()
        if not username:
            self.username_field.error_text = "Por favor, digite um nick!"; self.page.update(); return
        if self.is_username_taken(username):
            self.username_field.error_text = f"O nick '{username}' já existe. Tente outro."; self.page.update(); return
        self.username = username
        self.login_view.visible = False
        self.high_score_container.visible = False # Esconde o recorde
        self.difficulty_view.visible = True
        self.page.update()

    def select_difficulty(self, e):
        self.selected_difficulty = e.control.data
        self.current_quiz_questions = [q for q in self.full_quiz_data if q['difficulty'] == self.selected_difficulty]
        random.shuffle(self.current_quiz_questions)
        self.difficulty_view.visible = False
        self.quiz_view.visible = True
        self.username_display.value = f"Jogador: {self.username}"
        self.update_quiz_view()

    def update_quiz_view(self):
        self.score_text.value = f"Pontos: {self.score}"; self.lives_text.value = "❤️" * self.lives
        question_data = self.current_quiz_questions[self.current_question_index]
        self.question_text.value = question_data["question"]
        options = list(question_data["options"]); random.shuffle(options)
        correct_answer = question_data["correct_answer"]
        for i, btn in enumerate(self.answer_buttons):
            btn.text = options[i]; btn.data = options[i]
            btn.style.bgcolor = ft.Colors.WHITE24
            btn.disabled = False
            btn.on_click = lambda ev, ans=options[i]: self.check_answer(ev, ans, correct_answer)
        self.page.update()

    def check_answer(self, e, chosen_answer, correct_answer):
        self.disable_all_buttons()
        if chosen_answer == correct_answer:
            e.control.style.bgcolor = ft.Colors.GREEN
            self.score += 5
            self.page.update()
            time.sleep(0.75)
            self.show_ar_reward()
        else:
            e.control.style.bgcolor = ft.Colors.RED
            self.lives -= 1
            self.page.update()
            time.sleep(1.5)
            if self.lives == 0:
                self.show_final_screen(game_over=True)
            else:
                self.next_question(None)

    def show_ar_reward(self):
        self.page.bgcolor = None
        self.page.gradient = ft.LinearGradient(
            begin=ft.alignment.top_center, end=ft.alignment.bottom_center,
            colors=[ft.Colors.LIGHT_BLUE_100, ft.Colors.BLUE_GREY_50],
        )
        reward_image_filename = self.current_quiz_questions[self.current_question_index]["reward_image"]
        if not self.ar_app.set_overlay_image(reward_image_filename):
            self.page.snack_bar = ft.SnackBar(ft.Text(f"Erro ao carregar a imagem!"), bgcolor=ft.Colors.RED)
            self.page.snack_bar.open = True; self.page.update()
            time.sleep(0.75); self.next_question(None)
            return
        
        self.quiz_view.visible = False
        self.ar_view_container.visible = True
        self.ar_app.start(); self.page.update()
    
    def next_question(self, e):
        self.page.gradient = None
        self.page.bgcolor = ft.Colors.DEEP_PURPLE_400
        
        self.ar_app.stop()
        self.ar_view_container.visible = False
        if self.current_question_index < len(self.current_quiz_questions) - 1:
            self.current_question_index += 1
            self.quiz_view.visible = True
            self.update_quiz_view()
        else:
            self.show_final_screen(game_over=False)
        self.page.update()

    def show_final_screen(self, game_over=False):
        self.page.gradient = ft.LinearGradient(
            begin=ft.alignment.top_center, end=ft.alignment.bottom_center,
            colors=[ft.Colors.LIGHT_BLUE_100, ft.Colors.BLUE_GREY_50],
        )
        self.page.bgcolor = None
        
        self.quiz_view.visible = False; self.ar_view_container.visible = False; self.final_view.visible = True
        if game_over:
            self.final_message.value = "Game Over!"; self.final_message.color = ft.Colors.RED
            self.final_score_text.value = f"{self.username}, você ficou com {self.score} pontos."
        else:
            self.final_message.value = "Quiz Finalizado!"; self.final_message.color = ft.Colors.GREEN_700
            self.final_score_text.value = f"Parabéns, {self.username}! Pontuação final: {self.score}"
            self.save_score()
        self.page.update()
        
    def save_score(self):
        scores = self.load_scores()
        scores.append({"username": self.username, "score": self.score})
        scores = sorted(scores, key=lambda x: x['score'], reverse=True)[:10]
        with open(self.scores_file, 'w') as f: json.dump(scores, f, indent=4)

    def reset_quiz(self, e):
        self.page.gradient = None
        self.page.bgcolor = ft.Colors.DEEP_PURPLE_400
        
        self.reset_game_state(); self.username_field.value = ""; self.username_field.error_text = None
        self.final_view.visible = False
        self.login_view.visible = True
        self.high_score_container.visible = True
        self.load_and_display_high_score()

    def disable_all_buttons(self):
        for btn in self.answer_buttons: btn.disabled = True

def main(page: ft.Page):
    page.title = " Tech Trívia Challenge"
    page.window_width = 800
    page.window_height = 500
    page.padding = 0
    page.theme = ft.Theme(color_scheme=ft.ColorScheme(primary=ft.Colors.BLUE_600))
    page.bgcolor = ft.Colors.DEEP_PURPLE_400
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER
    
    ar_app = CameraApp(page)
    quiz_manager = QuizManager(page, ar_app)


    # Conteúdo principal que será centralizado
    main_content = ft.Container(
        content=ft.Stack(
            [
                quiz_manager.login_view,
                quiz_manager.difficulty_view,
                quiz_manager.quiz_view,
                quiz_manager.ar_view_container,
                quiz_manager.final_view,
            ]
        ),
        padding=20,
        alignment=ft.alignment.center,
        expand=True
    )


    app_layout = ft.Stack(
        [
            main_content,
            quiz_manager.high_score_container, 
        ],
        expand=True
    )
    
    splash_view = ft.Column(
        [
            ft.Icon(ft.Icons.BOLT_ROUNDED, color=ft.Colors.WHITE, size=80),
            ft.Text("Tech Trívia Challenge", size=30, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
            ft.ProgressRing(color=ft.Colors.WHITE, width=24, height=24, stroke_width=3)
        ],
        alignment=ft.MainAxisAlignment.CENTER,
        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        spacing=20
    )
    splash_container = ft.Container(
        content=splash_view,
        expand=True,
        alignment=ft.alignment.center
    )
    

    switcher = ft.AnimatedSwitcher(
        content=splash_container,
        transition=ft.AnimatedSwitcherTransition.FADE,
        duration=500,
        switch_in_curve=ft.AnimationCurve.EASE_IN,
        switch_out_curve=ft.AnimationCurve.EASE_OUT,
    )

    def show_main_app():
        time.sleep(3)
        switcher.content = app_layout
        page.update()
    
    def on_window_event(e):
        if e.data == "close":
            ar_app.stop()
            page.window_destroy()
    page.on_window_event = on_window_event
    
    page.add(switcher)
    
    threading.Thread(target=show_main_app, daemon=True).start()
    
    page.update()

ft.app(target=main, assets_dir="assets")