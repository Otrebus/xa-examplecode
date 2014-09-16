import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Insets;
import java.util.Random;

import javax.swing.JPanel;

class BoardPanel extends JPanel 
{
    int[] board = new int[Gui.WIDTH*Gui.WIDTH];
    Color[] colormap = { Color.BLACK, Color.GREEN, Color.BLUE, Color.RED, Color.YELLOW, Color.MAGENTA, Color.CYAN, Color.PINK, Color.WHITE, Color.LIGHT_GRAY };
    
    public void setBoard(int[] board)
    {
        for(int i = 0; i < board.length; i++)
            this.board[i] = board[i];
    }
    
    private int getTile(int x, int y)
    {
        return board[y*Gui.WIDTH + x];
    }
    
    private void doDrawing(Graphics g) 
    {
        Graphics2D g2d = (Graphics2D) g;

        Dimension size = getSize();
        Insets insets = getInsets();

        int w = size.width - insets.left - insets.right;
        int h = size.height - insets.top - insets.bottom;        
        
        g2d.setColor(Color.black);        
        g2d.fillRect(0, 0, w, h);

        float boxSizeW = (float)(w+1-Gui.WIDTH)/(float)Gui.WIDTH;
        float boxSizeH = (float)(h+1-Gui.WIDTH)/(float)Gui.WIDTH;
        
        float xAcc = 0;
        for (int x = 0; x < Gui.WIDTH; x++)
        {
            float newXAcc = xAcc + boxSizeW;
            float yAcc = 0;
            for(int y = 0; y < Gui.WIDTH; y++)
            {
                float newYAcc = yAcc + boxSizeH;
                g2d.setColor(colormap[getTile(x, y) % 10]);
                
                g2d.fillRect((int)xAcc, (int)yAcc, (int)(newXAcc - (int)xAcc), (int)(newYAcc - (int)yAcc));
                yAcc = newYAcc + 1.0f;
            }
            xAcc = newXAcc + 1.0f;
        }
    }
    
    @Override
    public void paintComponent(Graphics g) 
    {
        super.paintComponent(g);
        doDrawing(g);
    }
}