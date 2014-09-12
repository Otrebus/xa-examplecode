import se.neava.*;
import se.neava.Assembler.Assembler;
import se.neava.communicator.CommunicationEvent;
import se.neava.communicator.CommunicationEventHandler;
import se.neava.communicator.Communicator;
import se.neava.communicator.Communicator.BusyException;
import se.neava.communicator.Communicator.NoPortsFoundException;
import se.neava.compiler.CompileException;
import se.neava.compiler.Compiler;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.text.ParseException;
import java.util.Random;

import javax.swing.ImageIcon;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.ProgressMonitor;

import jssc.SerialPortException;

public class Gui extends JFrame  {
    
    private se.neava.compiler.Compiler compiler;
    private Communicator communicator;
    
    ProgressMonitor progressMonitor;

    /**
     * 
     */
    private static final long serialVersionUID = -8117657545598071724L;

    public static final int WIDTH = 20;
    
    int[] board = new int[WIDTH*WIDTH];
    
    private int getTile(int x, int y)
    {
        return board[y*WIDTH + x];
    }
    
    void handleInput(char key)
    {
        
    }
    
    public Gui() 
    {
        compiler = new se.neava.compiler.Compiler();
        try {
            communicator = new Communicator(null, 9600);
        } catch (NoPortsFoundException | SerialPortException e1) {
            JOptionPane.showMessageDialog(null, "Could not open port!\n" + e1.getMessage());
            System.exit(0);
        }
        
        this.addKeyListener( new KeyListener() { 
            @Override  
            public void keyPressed(KeyEvent e) 
            {
                handleInput(e.getKeyChar()); 
            }

            @Override
            public void keyReleased(KeyEvent arg0) {
                // TODO Auto-generated method stub
                
            }

            @Override
            public void keyTyped(KeyEvent arg0) {
                // TODO Auto-generated method stub
                
            }
        });
        BoardPanel dpnl = new BoardPanel();
        add(dpnl);
        dpnl.setBoard(board);
        JMenuBar menubar = new JMenuBar();
        ImageIcon icon = new ImageIcon("exit.png");
        
        final Gui parent = this;

        JMenu file = new JMenu("File");
        file.setMnemonic(KeyEvent.VK_F);

        JMenuItem eMenuItem = new JMenuItem("Exit", icon);
        JMenuItem fileOpener = new JMenuItem("Load...", icon);
        fileOpener.setMnemonic(KeyEvent.VK_L);
        eMenuItem.setMnemonic(KeyEvent.VK_E);
        eMenuItem.setToolTipText("Exit application");
        eMenuItem.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent event) {
                System.exit(0);
            }
        });
        
        fileOpener.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent event) {
                final JFileChooser fc = new JFileChooser();
                int returnVal = fc.showOpenDialog(parent);
                
                if (returnVal == JFileChooser.APPROVE_OPTION) {
                    File file = fc.getSelectedFile();
                    uploadFile(file);
            }
        }});

        file.add(eMenuItem);
        file.add(fileOpener);

        menubar.add(file);

        setJMenuBar(menubar);

        setTitle("Game gui");
        setSize(500, 500);
        setResizable(true);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(EXIT_ON_CLOSE);   
    }

    protected void uploadFile(File file) {
        System.out.println(file.getAbsolutePath());
        String text;
        bytes = null;
        try {
            bytes = Files.readAllBytes(file.toPath());
            text = new String(bytes,"UTF-8");
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return;
        }
        
        Compiler compiler = new Compiler();
        String code;
        try 
        {
            code = compiler.compile(text);
        } 
        catch (CompileException e1) 
        {
            // TODO Auto-generated catch block
            System.out.println("Compile error!");
            System.out.println(e1.what);
            return;
        }

        System.out.println(code);
        Assembler asm = new Assembler();
        try {
            bytes = asm.assemble(code);
        } catch (IOException | ParseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        try 
        { 
            acked = 0;
            chunkSize = 15;
            communicator.setDebugOutput(true);
            communicator.transmitCode(bytes, chunkSize);
            communicator.setEventHandler(new CommunicationEventHandler ()
                    {
                public void handleEvent(CommunicationEvent e) {
                    if(e.getType() == CommunicationEvent.MESSAGE)
                    {
                    }
                    else if(e.getType() == CommunicationEvent.RETRANSMITTED)
                        System.out.print("r");
                    else if(e.getType() == CommunicationEvent.FINISHED_UPLOADING)
                    {
                        progressMonitor.setProgress(1000);
                        System.out.println(" Finished uploading!");
                    }
                    else if(e.getType() == CommunicationEvent.GAVE_UP)
                        System.out.println(" Gave up!");
                    else if(e.getType() == CommunicationEvent.GOT_ACK)
                    {
                        gotAck();
                    }
                }
            });
            progressMonitor = new ProgressMonitor(this,
                    "Uploading...",
                    "", 0, 1000);
            progressMonitor.setProgress(0);
        } 
        catch (SerialPortException | BusyException e) 
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    
    void handleFrame(byte[] bytes)
    {
        System.out.println("Received a message: ");
        switch(bytes[0])
        {
        case 1:
            
            break;
        for(byte b : bytes)
            System.out.print((char) b);
        }
    }
    
    private void gotAck()
    {
        acked += chunkSize;
        System.out.print(".");
        progressMonitor.setProgress((1000*acked)/bytes.length);
    }
    
    byte[] bytes;
    int acked = 0;
    int chunkSize = 0;

    public static void main(String[] args) {
        
        EventQueue.invokeLater(new Runnable() {
            @Override
            public void run() {
                Gui ex = new Gui();
                ex.setVisible(true);
            }
        });
    }
    
    
}
