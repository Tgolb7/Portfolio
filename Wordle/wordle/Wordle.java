package wordle;

import java.awt.*;
import java.awt.event.*;
import java.util.*;
import java.io.*;
import javax.swing.*;

public class Wordle {
	File wordList = new File("WORDS.txt");
	File allWords = new File("valid-wordle-words.txt");
	JLabel entry[][] = new JLabel[6][5];
	int guessNum = 0;
	int letIndex = 0;
	char lastLetter = ' ';
	String guessArray[] = { "", "", "", "", "" };
	HashMap<Character, Integer> freq = new HashMap<>();
	HashMap<Character, Integer> revert = new HashMap<>();
	String targetWord;
	MyFrame frame;
	KeyListener list;

	Scanner reader; //reads words from list of possible answers
	Scanner checker; //checks if word is in valid words list

	public Wordle() {
		pickWord();
		setFreq();
		revert.putAll(freq);
		initGUI();

	}

	private void pickWord() {
		try {
			Random rand = new Random();
			targetWord = "SSSSS";
			while (Character.toString(targetWord.charAt(4)).equalsIgnoreCase("S")
					|| (Character.toString(targetWord.charAt(3)).equalsIgnoreCase("E")
							&& Character.toString(targetWord.charAt(4)).equalsIgnoreCase("D"))) { // ensure not plural
				int pick = rand.nextInt(3102); // 3102 = number of words in file
				reader = new Scanner(wordList);
				for (int i = 0; i < pick; i++) {
					targetWord = reader.nextLine().toUpperCase();
				}
				//System.out.println(targetWord); //show word in console
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void setFreq() {
		int count;
		for (int i = 0; i < 5; i++) {
			count = 0;
			if (freq.containsKey(targetWord.charAt(i))) {
				count = freq.get(targetWord.charAt(i));
				freq.put(targetWord.charAt(i), ++count);
			} else {
				freq.put(targetWord.charAt(i), 1);
			}
		}
	}

	public void initGUI() {
		frame = new MyFrame("Wordle", 500, 600);

		MyPanel title = new MyPanel("Wordle", Color.BLACK);
		frame.add(title, BorderLayout.NORTH);

		MyPanel center = new MyPanel(Color.DARK_GRAY);
		center.setLayout(new GridLayout(6, 5));
		frame.add(center, BorderLayout.CENTER);

		for (int i = 0; i < 6; i++) {
			for (int j = 0; j < 5; j++) {
				entry[i][j] = new JLabel("", JLabel.CENTER);
				entry[i][j].setFont(new Font(Font.SANS_SERIF, Font.PLAIN, 24));
				entry[i][j].setSize(50, 50);
				entry[i][j].setLocation(i * 50 + 5, j * 50 + 5);
				entry[i][j].setBorder(BorderFactory.createLineBorder(Color.BLACK));
				entry[i][j].setBackground(Color.DARK_GRAY);
				entry[i][j].setForeground(Color.WHITE);
				center.add(entry[i][j]);
			}
		}

		frame.addKeyListener(list = new KeyListener() {

			@Override
			public void keyTyped(KeyEvent e) {
				char ch = e.getKeyChar();
				String letter = Character.toString(ch);

				if (e.getExtendedKeyCode() == KeyEvent.VK_BACK_SPACE && letIndex > 0) {
					letIndex--;
					guessArray[letIndex] = "";
					updateGuess("", entry[guessNum][letIndex]);

				} else if (letter.matches("[a-zA-Z]") && letIndex < 5) {
					guessArray[letIndex] = letter.toUpperCase();

					updateGuess(letter, entry[guessNum][letIndex]);
					letIndex++;

				} else if (e.getKeyChar() == KeyEvent.VK_ENTER && guessNum <= 5 && letIndex == 5) {
					String guess = "";
					for (int i = 0; i < guessArray.length; i++) {
						guess += guessArray[i];
					}
					if (checkValid(guess) == true) {
						submitGuess(guessArray, freq);
						freq.putAll(revert);
						guessNum++;
						letIndex = 0;
					}
				}
			}

			@Override
			public void keyPressed(KeyEvent e) {}

			@Override
			public void keyReleased(KeyEvent e) {}

		});

		frame.validate();
	}

	public void updateGuess(String letter, JLabel square) {
		square.setText(letter.toUpperCase());
	}

	private void submitGuess(String[] str, HashMap<Character, Integer> letFreq) {
		String arrToStr = "";
		for (int i = 0; i < str.length; i++) {
			arrToStr += str[i];
		}

		for (int i = 0; i < 5; i++) { // GREEN LETTERS
			entry[guessNum][i].setFont(new Font(Font.MONOSPACED, Font.BOLD, 20));
			entry[guessNum][i].setForeground(new Color(235, 235, 235));
			if (str[i].equals(Character.toString(targetWord.charAt(i)))) {
				letFreq.put(targetWord.charAt(i), letFreq.get(targetWord.charAt(i)) - 1);
				entry[guessNum][i].setBackground(new Color(20, 160, 20));
				entry[guessNum][i].setOpaque(true);
			}
		}

		for (int i = 0; i < 5; i++) { // YELLOW LETTERS
			for (int j = 0; j < 5; j++) {
				if (str[i].equals(Character.toString(targetWord.charAt(j)))
						&& !str[i].equals(Character.toString(targetWord.charAt(i)))
						&& letFreq.get(targetWord.charAt(j)) > 0) {
					letFreq.put(targetWord.charAt(j), letFreq.get(targetWord.charAt(j)) - 1);
					entry[guessNum][i].setBackground(new Color(220, 220, 0));
					entry[guessNum][i].setOpaque(true);
				}
			}
		}

		for (int i = 0; i < 5; i++) {
			guessArray[i] = "";
		}
		frame.validate();

		if (arrToStr.equals(targetWord)) {
			endGame("win");
			frame.removeKeyListener(list);
		}
		if (guessNum == 5 && !arrToStr.equals(targetWord)) {
			endGame("lose");
			frame.removeKeyListener(list);
		}
	}

	private void endGame(String result) {
		Object[] options = { "PLAY AGAIN", "QUIT" };
		int option = JOptionPane.showOptionDialog(null, "You " + result + "! The word was: " + targetWord, "Message",
				JOptionPane.DEFAULT_OPTION, JOptionPane.INFORMATION_MESSAGE, null, options, null);
		if (option == 0) {
			frame.dispose();
			main(null);
		} else {
			System.exit(0);
		}

	}

	public boolean checkValid(String word) {
		try {
			checker = new Scanner(allWords);
			while (checker.hasNext()) {
				if (checker.nextLine().toUpperCase().equals(word)) {
					return true;
				}
			}
			return false;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public static void main(String[] args) {
		try {
			String laf = UIManager.getCrossPlatformLookAndFeelClassName();
			UIManager.setLookAndFeel(laf);
		} catch (Exception e) {
			System.out.println(e.getStackTrace());
		}

		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				new Wordle();
			}
		});
	}
}