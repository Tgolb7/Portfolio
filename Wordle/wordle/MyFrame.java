
package wordle;

import java.awt.BorderLayout;

import javax.swing.JFrame;

public class MyFrame extends JFrame {

	private static final long serialVersionUID = 1L;

	public MyFrame(String title, int width, int height) {
		this.setLayout(new BorderLayout());
		this.setSize(width, height);
		this.setResizable(false);
		this.setTitle(title);
		this.setLocationRelativeTo(null);
		this.setDefaultCloseOperation(EXIT_ON_CLOSE);
		this.setVisible(true);
	}

	public MyFrame(String title) {
		this.setTitle(title);
		this.setLocationRelativeTo(null);
		this.setDefaultCloseOperation(EXIT_ON_CLOSE);
		this.setVisible(true);
	}

}
