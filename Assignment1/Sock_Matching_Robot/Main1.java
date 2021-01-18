import java.util.*;
import java.lang.*;
import java.io.*;
import java.util.concurrent.locks.*;

//Class declaration of Sock
class Socks {
  //Declaring a instance variable to store and get the label of the sock
  int label;
  //Declaring a instance variable to check whether the sock is collected by the machine or not
  int collect;
  //Decalring a instance variable to store and get the colour of the sock
  int color;
  //Declaring a lock l which will be used to give a lock to the current working thread and blocks all other threads which are trying to take a lock on the shared resource.
  //ReentrantLock allow threads to enter into lock on a resource more than once
  ReentrantLock l = new ReentrantLock();
  //Constructor declaration of class Socks
  Socks(int s, int idx){
    this.color =s;
    collect = 0;
    this.label = idx;
  }
  //Constructor overloading to get a copy of the sock
  Socks(Socks s){
    this.color = s.color;
    this.collect = s.collect;
  }
  //Function to remove the lock on a sock
  public void unLock(){
    l.unlock();
  }
  //Function to get the lock on a sock
  public boolean getLock(){
    if(!l.tryLock()){
      return false;
    }else{
      return true;
    }
  }
}

//Class declaration of robotic arms
class Robots extends Thread {
  //Declaration of instance variables
  Socks[] s;
  int label;
    Socks sock;
    int sock_idx;
    //Override if any errors occur while selecting a sock
    @Override
    public void run()
    {
        try {
          chooseSock();
        }
        catch(Exception e){
          e.printStackTrace();
        }
        finally{} 
    }
  //Constructor declaration of Class Robots
  Robots(Socks s[], int i)
  {
    this.s = s;
    label = i;
    sock = null;
    sock_idx = -1;
  }
  //Function for the robotic arm to choose a sock
  public void chooseSock() throws Exception
  {
    //Robotic arms keep choosing socks until the socks exhaust 
    while(MatchingMachine.ls.size() < Main1.num_socks)
    {
      Random r = new Random();
      int i = r.nextInt(Main1.num_socks);
      ReentrantLock l = new ReentrantLock();
      //Choose a sock if doesn't have a lock and is also not accessed before
      if(s[i].getLock())
      {
        try{
          //If not collected already then the thread will choose this sock
          if(s[i].collect == 0)
          {
            sock = new Socks(s[i]);
            sock_idx = i;
            s[i].collect = 1;
            sock.collect = 0;
            sock.label = i;
            System.out.println("Robotic arm " +this.label+  " chose sock with label "+i);
            //Add the sock to the machine
            MatchingMachine.ls.add(sock);
          }
          //If the sock is already accessed then the thread couldn't access the same sock
          else{
            System.out.println("Robotic arm " + this.label+" tried but couldn't access sock with label "+i);
          }
        }catch(Exception e){
          e.printStackTrace();
        }finally{
          //After accessing and adding the sock remove the lock on the sock
          s[i].unLock();
        }
      }
    }
  }

}

//Class declaration of MatchingMachine
class MatchingMachine extends Thread{
  //Declaring instance variables for storing and getting the colours WHITE, BLACK, BLUE and GREY
  int WHITE;
  int BLACK;
  int BLUE;
  int GREY;
  public static MatchingMachine m ;
  //Array list to store the socks that are in the matching machine and it is made static as it will be accessed by all the arms of the robot
  public static ArrayList<Socks> ls;
  //Declaring a static variable to get and store the number of socks that are matched by the machine
  public static int match_socks;
  //Constructor declaration of class MatchingMachine
  public MatchingMachine()
  {
    WHITE = Integer.MIN_VALUE;
    BLACK = Integer.MIN_VALUE;
    BLUE = Integer.MIN_VALUE;
    GREY = Integer.MIN_VALUE;
    match_socks = 0;
    ls = new ArrayList<Socks>();
  }
  //To get the static instance of the machine since it will be accessed by all the arms of the robot
  public static MatchingMachine getInstance()
  {
    if(m != null){
      return m;
    }else{
      m = new MatchingMachine();
      match_socks = 0;
      return m;
    }
  }

  // //Add the sock to the list in a synchronized fashion
  // public synchronized void Push(Socks s)
  // {
  //   ls.add(s);
  // }

  public void run()
  {
    //Keep on matching the socks if possible until the socks exhaust
    while(MatchingMachine.match_socks <= Main1.num_socks)
    {
      if(ls.size() != 0){
        Random r = new Random();
        int i = r.nextInt(ls.size());
        String[] colour = {"WHITE","BLACK","BLUE","GREY"};
        //Match the sock if we already have one sock of same color in the matching machine
        if(ls.get(i).collect == 0)
        {
          MatchingMachine.match_socks++;
          //Get the colour of the sock that is going into the matching machine
          String color = colour[ls.get(i).color-1];
          if(color == "WHITE"){
            //If a sock of WHITE colour doesn't exist then just add the sock
            if(WHITE == Integer.MIN_VALUE){
              WHITE = i;
              ls.get(i).collect =1;
            }
            //If it exists then match these both WHITE socks
            else{
              System.out.println("Socks with colour WHITE and labels "+ls.get(WHITE).label+ " and "+ls.get(i).label + " were matched by the matching machine");
              WHITE = Integer.MIN_VALUE;
              ls.get(i).collect = 1;
            }
          }
          else if(color == "BLACK"){
            //If a sock of BLACK colour doesn't exist then just add the sock
            if(BLACK == Integer.MIN_VALUE){
              BLACK = i;
              ls.get(i).collect =1;
            }
            //If it exists then match these both BLACK socks
            else{
              System.out.println("Socks with colour BLACK and indices "+ls.get(BLACK).label+ " and "+ls.get(i).label + " were matched by the matching machine");
              BLACK = Integer.MIN_VALUE;
              ls.get(i).collect = 1;
            }
          }
          else if(color == "BLUE"){
            //If a sock of BLUE colour doesn't exist then just add the sock
            if(BLUE == Integer.MIN_VALUE){
              BLUE = i;
              ls.get(i).collect =1;
            }
            //If it exists then match these both BLUE socks
            else{
              System.out.println("Socks with colour BLUE and indices "+ls.get(BLUE).label+ " and "+ls.get(i).label + " were matched by the matching machine");
              BLUE = Integer.MIN_VALUE;
              ls.get(i).collect = 1;
            }
          }
          else{
            //If a sock of GREY colour doesn't exist then just add the sock
            if(GREY == Integer.MIN_VALUE){
              GREY = i;
              ls.get(i).collect =1;
            }
            //If it exists then match these both GREY socks
            else{
              System.out.println("Socks with colour GREY and indices "+ls.get(GREY).label+ " and "+ls.get(i).label + " were matched by the matching machine");
              GREY = Integer.MIN_VALUE;
              ls.get(i).collect = 1;
            }
          }
        }
        if(MatchingMachine.match_socks == Main1.num_socks)
          break;
      }
    }
  }
}

class Main1 {
    //Static variable declaration for getting and storing the number of socks
    public static int num_socks;
    public static void main(String[] args) throws Exception{
      //Scan the input
      Scanner in = new Scanner(System.in);
      System.out.println("Enter the number of socks:");
      // Get the number of socks given as input in the terminal after compiling the code
      int n = in.nextInt();
      num_socks = n;
      System.out.println("Enter the number of Robotic arms:");
      //Get the number of threads given as input
      int num_threads = in.nextInt();
      //To store the colour and index of all the socks
      Socks[] socks_list = new Socks[num_socks];
      //To get the robotic arms given the number of threads
      Robots[] robots = new Robots[num_threads];
      //Initialize the machine 
      MatchingMachine machine = new MatchingMachine().getInstance();
      String[] colour = {"WHITE","BLACK","BLUE","GREY"};
      int i=0;
      //Allot index and colour randomly to each and every sock
      while(i<num_socks){
          Random r = new Random();
          int x = r.nextInt(4)+1;
          socks_list[i] = new Socks(x, i);
          System.out.println("Sock with label "+i+"'s colour is "+colour[x-1]);
          i++;
      }
      //Keep initializijng and start the threads until the number of socks in the matching machine doesn't exceed total number of socks
      i=0;
      while(i<num_threads)
      {
        if(machine.ls.size() < num_socks)
        {
          //Initialie the robotic arms and start the threads
          robots[i] = new Robots(socks_list, i);
          robots[i].start();
        }
        i++;
      }
      //Start the machine thread
      machine.start();
    }
}