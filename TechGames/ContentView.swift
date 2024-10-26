import SwiftUI

struct ContentView: View {
    
    @State var totalGames: Int = UserDefaults.standard.integer(forKey: "totalGames")
    @State var maxScore: Int = UserDefaults.standard.integer(forKey: "max")
    @State var point: Int = 0
    @State var timeRemaining: Int = 5
    
    var colors: [Color] = [.red, .green, .yellow, .orange, .blue]
    @State var focusColor: Color = .black
    
    var colorsText: [String] = ["Red", "Green", "Yellow", "Orange", "Blue"]
    @State var focusColorText: String = ""
    
    
    @State var timer: Timer? = nil
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.3)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                                
                Text("Color Match Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 40)
                
                HStack(spacing: 40) {
                    VStack {
                        Text("Total Games")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("\(totalGames)")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    
                    VStack {
                        Text("Max Point")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("\(maxScore)")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
                
                // Current Points
                VStack {
                    Text("Current Points")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("\(point)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                }
                
                Divider()
                    .padding(.horizontal, 50)
                
                Spacer()
                
                // Renkli Metin ve Geri Sayım
                VStack(spacing: 30) {
                    Text(focusColorText)
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(focusColor)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 5))
                    
                    Text("Time Remaining: \(timeRemaining)s")
                        .font(.title2)
                        .foregroundColor(.red)
                        .transition(.opacity)
                        .animation(.easeInOut, value: timeRemaining)
                }
                
                Spacer()
                
                // True ve False Butonları
                HStack(spacing: 40) {
                    // True Butonu
                    Button(action: {
                        handleAnswer(isTrueButton: true)
                    }) {
                        Text("True")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(width: 120, height: 60)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // False Butonu
                    Button(action: {
                        handleAnswer(isTrueButton: false)
                    }) {
                        Text("False")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(width: 120, height: 60)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
                
                // Reset Butonu
                Button(action: {
                    resetGameData()
                }) {
                    Text("Reset Game Data")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }
                .shadow(radius: 5)
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            // Verileri UserDefaults'tan al
            totalGames = UserDefaults.standard.integer(forKey: "totalGames")
            maxScore = UserDefaults.standard.integer(forKey: "max")
            selectNewColor()
            startTimer() // Timer'ı başlat
        }
    }
    
    // Butona tıklanma durumunu kontrol eden fonksiyon
    func handleAnswer(isTrueButton: Bool) {
        stopTimer() // Butona basıldığında önce timer'ı durdur
        
        if (isTrueButton && checkColorMatch()) || (!isTrueButton && !checkColorMatch()) {
            point += 5
            if point > maxScore {
                maxScore = point
                UserDefaults.standard.set(maxScore, forKey: "max")
            }
        } else {
            point = 0
            totalGames += 1
            UserDefaults.standard.set(totalGames, forKey: "totalGames")
        }
        
        selectNewColor()
        startTimer() // Yeni renk seçildikten sonra timer yeniden başlar
    }
    
    // Oyunu sıfırlayan fonksiyon
    func resetGameData() {
        UserDefaults.standard.removeObject(forKey: "max")
        UserDefaults.standard.removeObject(forKey: "totalGames")
        maxScore = 0
        totalGames = 0
        point = 0
        timeRemaining = 5
        stopTimer() // Timer'ı sıfırlıyoruz
        selectNewColor()
    }
    
    // Renk ve metni kontrol eden yardımcı fonksiyon
    func checkColorMatch() -> Bool {
        switch focusColorText {
        case "Red":
            return focusColor == .red
        case "Green":
            return focusColor == .green
        case "Yellow":
            return focusColor == .yellow
        case "Orange":
            return focusColor == .orange
        case "Blue":
            return focusColor == .blue
        default:
            return false
        }
    }
    
    // Yeni rastgele renk ve metin seç
    func selectNewColor() {
        if let randomColor = colors.randomElement() {
            focusColor = randomColor
        }
        
        if let randomFocusColorText = colorsText.randomElement() {
            focusColorText = randomFocusColorText
        }
    }
    
    // Timer'ı başlat
    func startTimer() {
        timeRemaining = 5 // Süreyi sıfırlayıp 5 saniyeye başlatıyoruz
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeRemaining -= 1
            if timeRemaining == 0 {
                point = 0
                totalGames += 1
                UserDefaults.standard.set(totalGames, forKey: "totalGames")
                stopTimer() // Süre bittiğinde timer durduruluyor
                selectNewColor() // Yeni renk seçiliyor
                startTimer() // Timer yeniden başlatılıyor
            }
        }
    }
    
    // Timer'ı durdur
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

