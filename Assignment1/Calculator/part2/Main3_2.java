import java.util.List;

import java.math.BigDecimal;
import java.math.MathContext;

import java.awt.Font;
import java.awt.Color;
import java.awt.EventQueue;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.JButton;
import javax.swing.SwingWorker;
import javax.swing.SwingConstants;

//Class declaration of Main calculator class for multiple numbers selection by the users
//implements standard java keylistner interface
public class Main3_2 implements KeyListener{
	//Declaration of instance variables
	//main window frame
	private JFrame frame;
	//state of input and operation selected
	private Integer state = 0, op;
	//textbox object
	private JTextField textbox;
	//number Buttons
	public JButton[] num_key = new JButton[10];
	//function buttons
	public JButton[] func_key = new JButton[5];
	//number highlight object
	private buttonHighlight numberHighlight = new buttonHighlight(num_key, 0);
	//function highlight
	private buttonHighlight functionHighlight = new buttonHighlight(func_key, 1);
	//labels for instructions
	private JLabel exit_label;
	private JLabel new_label;
	private JLabel space_label;
	private JLabel clear_label;
	private JLabel space_label_1;

	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					//create a new object on start
					Main3_2 window = new Main3_2();
					window.frame.setVisible(true);
					window.frame.setFocusable(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}
	public Main3_2() {
		initialize();
		//keylistner is added on the main frame
		frame.addKeyListener(this);
		//start the number highlight thread
		numberHighlight.execute();
	}

	//Function to render all the graphics with all the properties required
	private void initialize() {
		//Adjust the frame size and font
		frame = new JFrame();
		frame.setResizable(false);
		frame.setBounds(500, 200, 390, 500);
		frame.getContentPane().setBackground(Color.BLACK);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(null);
		//Set the textbox size and font where the output will be displayed
		textbox = new JTextField();
		textbox.setHorizontalAlignment(SwingConstants.CENTER);
		textbox.setFont(new Font("Arial", Font.BOLD, 20));
		textbox.setEditable(false);
		textbox.setBounds(10, 11, 370, 50);
		frame.getContentPane().add(textbox);
		textbox.setColumns(10);
		//Displaying instructions for the sake of users to operate the calculator
		JLabel instr_label = new JLabel("INSTRUCTIONS:");
		instr_label.setBounds(10, 365, 400, 30);
		instr_label.setForeground(Color.WHITE);
		instr_label.setFont(new Font("Arial", Font.BOLD, 15));
		frame.getContentPane().add(instr_label);
		//For instruction to select number
		new_label = new JLabel("Press ENTER to select the highlighted number");
		new_label.setBounds(10, 385, 400, 30);
		new_label.setForeground(Color.WHITE);
		new_label.setFont(new Font("Arial", Font.BOLD, 15));
		frame.getContentPane().add(new_label);
		//For instruction to select operator
		space_label = new JLabel("Press ENTER to select the highlighted operator");
		space_label.setBounds(10, 400, 400, 30);
		space_label.setForeground(Color.WHITE);
		space_label.setFont(new Font("Arial", Font.BOLD, 15));
		frame.getContentPane().add(space_label);
		//For instruction to clear the textbox
		clear_label = new JLabel("Press Delete key to clear the output");
		clear_label.setBounds(10, 415, 400, 30);
		clear_label.setForeground(Color.WHITE);
		clear_label.setFont(new Font("Arial", Font.BOLD, 15));
		frame.getContentPane().add(clear_label);
		//For exiting the window
		exit_label = new JLabel("Press Esc to exit the window");
		exit_label.setBounds(10, 430, 400, 30);
		exit_label.setForeground(Color.WHITE);
		exit_label.setFont(new Font("Arial", Font.BOLD, 15));
		frame.getContentPane().add(exit_label);
		//Creating buttons for numbers
		for(int i = 0;i<10;i++){
			num_key[i] = new JButton(String.valueOf(i));
			num_key[i].setBackground(new Color(224, 223, 219));
			num_key[i].setFont(new Font("Arial", Font.BOLD, 20));
			frame.getContentPane().add(num_key[i]);
		}
		//Creating buttons for operators and functions
		func_key[0] = new JButton("+");
		func_key[1] = new JButton("-");
		func_key[2] = new JButton("*");
		func_key[3] = new JButton("/");
		func_key[4] = new JButton("Del");
		for(int i = 0;i<5;i++){
			func_key[i].setBackground(new Color(255, 165, 0));
			func_key[i].setFont(new Font("Arial", Font.BOLD, 25));
			frame.getContentPane().add(func_key[i]);
		}
		num_key[0].setBounds(140,250,100,50);
		num_key[1].setBounds(20,190,100,50);
		num_key[2].setBounds(140,190,100,50);
		num_key[3].setBounds(260,190,100,50);
		num_key[4].setBounds(20,130,100,50);
		num_key[5].setBounds(140,130,100,50);
		num_key[6].setBounds(260,130,100,50);
		num_key[7].setBounds(20,70,100,50);
		num_key[8].setBounds(140,70,100,50);
		num_key[9].setBounds(260,70,100,50);
		func_key[0].setBounds(20,250,100,50);
		func_key[1].setBounds(20,310,100,50);
		func_key[2].setBounds(260,250,100,50);
		func_key[3].setBounds(260,310,100,50);
		func_key[4].setBounds(140,310,100,50);

	}
	
	//method the get the function binding corresponding to input number
	private String getOp(Integer num){
		if(num ==0) return "+";
		else if(num==1)return "-";
		else if(num==2) return "*";
		else if(num==3) return "/";
		else if(num==4) return "Del";
		else return null;
	}

	@Override
	//Function to implement action taken by the user based on the states
	// Here state 0 means initial stage without input and then state 1 means that one number was entered 
	//state 2 means function was selected and state 3 means atleast one digit was selected and finally stage 4 means that the results were displayed
	public void keyPressed(KeyEvent e) {
		//If key pressed is Esc then exit the window
		if(e.getKeyCode() == KeyEvent.VK_ESCAPE){
			System.exit(0);
		}
		//enter number
		if(e.getKeyCode() == KeyEvent.VK_ENTER){
			if(state != 4){
				if(state == 0){
					functionHighlight.execute();
					state = 1;
				}
				else if(state == 2)
					state = 3;
				textbox.setText(textbox.getText() + String.valueOf(numberHighlight.i));
			}
		}
		//select function or evaluate
		if(e.getKeyCode() == KeyEvent.VK_SPACE){
			if(state == 1){
				op = functionHighlight.i;
				textbox.setText(textbox.getText() + getOp(op));
				state = 2;
				functionHighlight.cancel(true);
			}
			else if(state == 3){
				num_key[numberHighlight.i].setBackground(new Color(224, 223, 219));
				func_key[op].setBackground(new Color(255, 165, 0));
				numberHighlight.cancel(true);
				state = 4;
				textbox.setText(evalexp(textbox.getText()));
				functionHighlight = new buttonHighlight(func_key, 1);
				functionHighlight.execute();
			}
			else if(state == 4){
				op = functionHighlight.i;
				functionHighlight.cancel(true);
				textbox.setText(textbox.getText() + getOp(op));
				numberHighlight = new buttonHighlight(num_key, 0);
				numberHighlight.execute();
				state = 2;
			}
		}
		//clear input when C was pressed
		if(e.getKeyCode() == KeyEvent.VK_DELETE){
			if(state == 1){
				op = functionHighlight.i;
				functionHighlight.cancel(true);
				func_key[op].setBackground(new Color(255, 165, 0));
			}
			else if(state == 2 || state == 3){
				func_key[op].setBackground(new Color(255, 165, 0));
			}
			else if(state == 4){
				op = functionHighlight.i;
				functionHighlight.cancel(true);
				func_key[op].setBackground(new Color(255, 165, 0));
				numberHighlight = new buttonHighlight(num_key, 0);
				numberHighlight.execute();
			}
			functionHighlight = new buttonHighlight(func_key, 1);
			textbox.setText("");
			state = 0;
		}
	}
	@Override
	public void keyReleased(KeyEvent arg0) {}
	@Override
	public void keyTyped(KeyEvent arg0) {}

	//Function to evaluate the expression with two numbers and one operator
	private String evalexp(String expr){
		//bigdecimal used for long user inputs
		BigDecimal num1, num2, ans, temp = new BigDecimal("0");
		int check = 1;
		//find the position of function
		while(Character.isDigit(expr.charAt(check)) || expr.charAt(check) == '.')
			check++;
		//extract numbers from expression
		num1 = new BigDecimal(expr.substring(0,check));
		num2 = new BigDecimal(expr.substring(check + 1,expr.length()));
		//division by zero error
		if(num2.compareTo(temp) == 0 && expr.charAt(check) == '/')
			return "Err - invalid input";
		//evaluate functions
		if(expr.charAt(check) == '+')
			ans = num1.add(num2);
		else if(expr.charAt(check) == '-')
			ans = num1.subtract(num2);
		else if(expr.charAt(check) == '*')
			ans = num1.multiply(num2);
		else 
			ans = num1.divide(num2, MathContext.DECIMAL32);
		return ans.toString();
	}
}

//Class decalration of buttonHighlight and this class objects are generate events to highlight different object on UI
class buttonHighlight extends SwingWorker<Integer, Integer> {

//JButton takes the set of buttons to be highlighted and there are two types of object highlight one for numbers and other for keys
  private JButton[] button_obj;
  public Integer type, i = 0;
 //constructor sets the global variables
  buttonHighlight(JButton[] num_key, Integer type) {
    this.button_obj = num_key;
    this.type = type;
  }

  @Override
  //Function to increment the thread based on the type of button, and then sleeps for 1.2 second
  protected Integer doInBackground() throws Exception {
	  while(true){
	  	//type 1 is functions and there are 4 functions [+,-,*,/]
		 if(type == 1)
			 i = (i+1)%4;
		//type 0 is number and there are 10 numbers [0-9]
		 else
			 i = (i+1)%10;
		  //value is published for UI update from EHT
		  publish(i);
		  Thread.sleep(1200);
	  }
  }
//Function process it updates the color of current object and changes back the color of previous object when a value is published from the doInBackground function
  protected void process(final List<Integer> buttons) {
    for (Integer i : buttons) {
    	if(type == 1){
    		button_obj[i].setBackground(new Color(223, 244, 62));
    		button_obj[i>0?((i-1)):3].setBackground(new Color(255, 165, 0));
    	}
    	else{
    		button_obj[i].setBackground(new Color(83, 62, 244));
    		button_obj[i>0?((i-1)):9].setBackground(new Color(224, 223, 219));
    	}
    }
  }
}