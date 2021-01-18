import java.util.*;
import java.lang.*;
import java.io.*;
import java.util.concurrent.locks.*; 

//Class declaration of Record
class Record {
	//Instance variables 
	//For roll number, name of the person, webmail_id, marks of the student, Type of teacher_type - Course coordinator, TA1, TA2
	String roll_no;
	int marks;
	String teacher_type;	
	String name;
	String email_id;
	//Declaring a lock l which will be used to give a lock to the current working thread and blocks all other threads which are trying to take a lock on the shared resource.
  	//ReentrantLock allow threads to enter into lock on a resource more than once
	Lock recordLock = new ReentrantLock();
	//Constructor declaration of class Record
	Record(String roll_no, String name, String email_id, int marks, String teacher_type){
		this.roll_no = roll_no;
		this.name = name;
		this.email_id = email_id;
		this.marks = marks;
		this.teacher_type = teacher_type;
	}
	//Function to get the record in string format where fields are separated by ','
	public String toString() {
		return roll_no+","+name+","+email_id+","+marks+","+teacher_type+"\n";
	}
	//Function to modify the record where the marks and type of teacher will be updated
	public void modifyRecord(String label, int synchronize, int update, int marks) {
		//If updation to be done with synchronizehronization then put a lock on the record
		if(synchronize == 2) {
			recordLock.lock();
		}
		//If marks are to be deducted then multiply with -1 since subtraction is to be done
		if(update == 2) {
			marks = -1*marks;
		}
		//Update marks and the teacher who modified the marks
		this.marks += marks;
		this.teacher_type = label;
		System.out.println("Updating record with " + marks + " label : "+ label);
		//Find the record which needs to be modified by finding the record index initially
		int idx =0;
		for(Record r:Main2.recordList){
			if(r.toString().contains(roll_no)){
				break;
			}
			idx++;
		}
		//Modify the record after finding th index 
		Main2.recordList.set(idx, this);
		//Once the updation is done then remove the lock if a lock was put on the record for the sake of synchronizehronizatioon purpose
		if(synchronize == 2) {
			recordLock.unlock();
		}

	}	
}
//Class declaration of Modifier
class Modifier extends Thread{
	//Instance variables
	//For roll number, marks, type of updation, synchronization and the label which can be one of these CC, TA1 and TA2.
	String label;
	String roll_no;
	int update;
	int marks;
	int synchronize;
	//Constructor decalaration of class Modifier
	Modifier(String label,String roll_no,int update,int marks,int synchronize){
		this.label = label;
		this.roll_no = roll_no;
		this.update = update;
		this.marks = marks;
		this.synchronize = synchronize;
	}
	
	public void run()
	{
		//Find the index of the record in the list that needs to be modified
		int idx =0;
		for(Record r:Main2.recordList){
			if(r.toString().contains(roll_no)){
				break;
			}
			idx++;
		}
		//int idx = Main2.recordList.indexOf(roll_no);
		System.out.println(idx);
		//Find the record
		Record r= Main2.recordList.get(idx);
		//Update only if initial evaluation was done by TA1 or TA2 or else if it was done by CC then update if the modification is being done by CC.
		if(!r.teacher_type.equals("CC") || label.equals("CC"))
		{
			System.out.println("Updating record for roll number : " + roll_no);
			r.modifyRecord(label, synchronize, update, marks);
			//Update all the three files required
			try {
				Main2.updateFiles();
				System.out.println("Files updated");
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
//Main class decalaration
class Main2{
	//Declare a list to store the records in it
	static ArrayList<Record> recordList = new ArrayList<Record>();	
	//Declare a variable for the sake of synchronization and the user will be able to choose whether to do updation with synchronization or not
	static int synchronize=2;
	//For the file level lock
	private static boolean fileLock = false;
	//main funtion
	public static void main(String[] args)throws IOException, InterruptedException  {
		//Function to get the records from the Stud_info.txt and to store them in a list and to initialize all the other files by updating them 
		initialiseRecords();
		//Based on the given input by the user perform updation on the records
		while(true) {
			Scanner in = new Scanner(System.in);
			//Scan inputs
			System.out.println("Enter Student roll number: ");
			String student1 = in.next();
			
			System.out.println("Enter teacher’s role(CC, TA1, TA2): ");
			String teacher_type1 = in.next();
			
			System.out.println("Update Marks : " + "\n" + "1. Increase" + "\n" + "2. Decrease");
			int update1 = in.nextInt();
			
			System.out.println("Mark to add: ");
			int marks1 = in.nextInt();

			System.out.println("Enter Student roll number: ");
			String student2 = in.next();
			
			System.out.println("Enter teacher’s role(CC, TA1, TA2): ");
			String teacher_type2 = in.next();
						
			System.out.println("Enter '1' for increasing marks and '2' for decreasing marks");
			int update2 = in.nextInt();
			
			System.out.println("Marks to add: ");
			int marks2 = in.nextInt();
			
			System.out.println("Enter '1' for without synchorization and '2' for with synchorization");
			synchronize = in.nextInt();
			//Create two threads for both the updations to be done based on the given inputs
			Thread t1 = new Thread(new Modifier(teacher_type1,student1,update1,marks1,synchronize));
			//Start the thread 1
			t1.start();
			Thread t2 = new Thread(new Modifier(teacher_type2,student2,update2,marks2,synchronize));
			//Start the thread 2
			t2.start();
			//To ensure that t1 is terminated before any other thread starts runninng
			t1.join();
			//To ensure that t2 is terminated before any other thread starts runninng
			t2.join();
			//After modifications are done type yes if you want to further modify or else no to exit the process
			String c;
			do {
				System.out.println("Do you want to continue? yes/no");
				c = in.next();
			}while(!c.toLowerCase().equals("yes") && !c.toLowerCase().equals("no"));
			if(c.toLowerCase().equals("no"))
				break;
		}
	}
	//Function to initialize the records list by getting the records from the Stud_Info.txt
	private static void initialiseRecords() throws IOException {
		FileReader fr = new FileReader("Stud_Info.txt");
		BufferedReader br = new BufferedReader(fr);
		String s;
		String[] words;
		while((s=br.readLine())!=null){
			words = s.split(",");
			Record r = new Record(words[0],words[1],words[2],Integer.parseInt(words[3]),words[4]);
			recordList.add(r);
		}
		fr.close();
		updateFiles();
	}
	//Function to update all the files by getting the copy of the modified records
	static void updateFiles() throws IOException
	{
		//For synchorization purpose manually put a lock on the file
		if(synchronize==2)
		{
			while(fileLock) {
				continue;
			}
			fileLock = true;
		}
		//Get the copy of the records modified to update the files
		ArrayList<Record> recordListCopy = new ArrayList<Record>();
		for (Record record: recordList) {
			recordListCopy.add(record);
		}
		updateSortedNameFile(recordListCopy);
		updateSortedRollFile(recordListCopy);
		updateStudInfoFile(recordListCopy);
		//Unlock the file level lock
		if(synchronize==2)
		{
			fileLock = false;
		}
		
	}
	//Function to update Stud_Info.txt file by writing the records values in it
	static void updateStudInfoFile(ArrayList<Record> recordListCopy) throws IOException
	{
		FileWriter writer = new FileWriter("Stud_Info.txt"); 
		System.out.println("Updated Stud_Info.txt file :");
		System.out.println("");
		for(Record r: recordListCopy) {
		  writer.write(r.toString());
		  System.out.println(r.toString());
		}
		writer.close();
	}
	//Function to update Sorted_Name.txt file by sorting the records based on the roll the numbers of the students
	static void updateSortedRollFile(ArrayList<Record> recordListCopy) throws IOException
	{
		Collections.sort(recordListCopy, new Comparator<Record>() {
			  public int compare(Record c1, Record c2) {
			    if (c1.roll_no.compareToIgnoreCase(c2.roll_no) <0) return -1;
			    if (c1.roll_no.compareToIgnoreCase(c2.roll_no) >0) return 1;
			    return 0;
			  }});
		FileWriter writer = new FileWriter("Sorted_Roll.txt"); 
		//System.out.println("Updated Sorted_Roll.txt file :");
		//System.out.println("");
		for(Record r: recordListCopy) {
		  writer.write(r.toString());
		  //System.out.println(r.toString());
		}
		writer.close();
		System.out.println("Sorted_Roll.txt file has been updated");
	}
	//Function to update Sorted_Name.txt file by sorting the records based on the names 
	static void updateSortedNameFile(ArrayList<Record> recordListCopy) throws IOException
	{
		Collections.sort(recordListCopy, new Comparator<Record>() {
			  public int compare(Record c1, Record c2) {
			    if (c1.name.compareToIgnoreCase(c2.name) <0) return -1;
			    if (c1.name.compareToIgnoreCase(c2.name) >0) return 1;
			    return 0;
			  }});
		FileWriter writer = new FileWriter("Sorted_Name.txt"); 
		//System.out.println("Updated Sorted_Name.txt file :");
		//System.out.println("");
		for(Record r: recordListCopy) {
		  writer.write(r.toString());
		  // System.out.println(r.toString());
		}
		writer.close();
		System.out.println("Sorted_Name.txt file has been updated");
	}
	
}