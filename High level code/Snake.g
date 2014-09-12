/*extern void setUartCallback(char[], function (char) -> void);
extern void uartTransmit(char, char[]);
extern void toggleLed();

Blinker blinker;

class Blinker
{
    long blinksLeft;
    bool isblinking;

    void init()
    {
        blinksLeft = 0l;
        isblinking = false;
        return;
    }

    void blinkFor(long times)
    {
        if(isblinking == false)
        {
            isblinking = true;
            blinksLeft = times*2l;
            blinkOnce();
        }
        return;
    }

    void blinkOnce()
    {
        if(blinksLeft > 0l)
        {
            toggleLed();
            blinksLeft = blinksLeft - 1l;
            after 250l msec before 5l msec blinkOnce();
        }
        else
            isblinking = false;
        return;
    }
}

object Main
{
    char[30] msgBuf;
    void main()
    {
        setUartCallback(msgBuf, Main.handleMessage);
        blinker.init();
        return;
    }
    
    long pow10(char n)
    {
        if(n == 0c)
            return 1l;
        return (10l)*pow10(n-1c);
    }

    char itoa(char n)
    {
        return (char) (n - 48c);
    }

    long parseNum(char length, char[] msg)
    {
        long sum;
        int index;
        char pow;
        index = 0i;
        sum = 0l;
        pow = length - 1c;
        while(pow >= 0c)
        {
            sum = sum + pow10(pow)*(long) itoa(msg[index]);
            index = index + 1i;
            pow = pow - 1c;
        }
        return sum;
    }

    void handleMessage(char length)
    {
        long l;
        l = parseNum(length, msgBuf);
        uartTransmit(5c, "hello");
        blinker.blinkFor(l);
        return;
    }
} 

*/

/*

extern void setUartCallback(function (char, char[]) -> void);
extern void uartTransmit(char, char[]);
extern void toggleLed();

Caller c1;
Caller c2;
Caller c3;
Caller c4;
Caller c5;

class Caller
{
     long count;

     void init()
     {
         count = 0l;
         return;
     }

     void chainInc(long n, long times)
     {
         if(times < 1l)
             return;
         Counter.incCount(n);
         after 5l msec before 2l msec chainInc(n, times - 1l);
         return;
     }
}

object Counter
{
    long count;

    void incCount(long amount)
    {
        long i;
        i = 1l;
        while(i <= amount)
        {
            count = count + 1l;
            i = i + 1l;
        }
        return;
    }

    void init()
    {
        count = 0l;
        return;
    }

    long get()
    {
        return count;
    }
}

object Main
{
    char[6] buf;
    void main()
    {
        setUartCallback(Main.handleMessage);
        return;
    }
    
    long pow10(char n)
    {
        if(n == 0c)
            return 1l;
        return (10l)*pow10(n-1c);
    }

    char itoa(char n)
    {
        return (char) (n - 48c);
    }

    long parseNum(char length, char[] msg)
    {
        long sum;
        int index;
        char pow;
        index = 0i;
        sum = 0l;
        pow = length - 1c;
        while(pow >= 0c)
        {
            sum = sum + pow10(pow)*(long) itoa(msg[index]);
            index = index + 1i;
            pow = pow - 1c;
        }
        return sum;
    }

    void atoi(long l)
    {
        long q;
        q = l / 100000l;
        buf[0i] = (char) q;
        l = l - q*100000l;
        q = l / 10000l;
        buf[1i] = (char) q;
        l = l - q*10000l;
        q = l / 1000l;
        buf[2i] = (char) q;
        l = l - q*1000l;
        q = l / 100l;
        buf[3i] = (char) q;
        l = l - q*100l;
        q = l / 10l;
        buf[4i] = (char) q;
        l = l - q*10l;
        q = l / 1l;
        buf[5i] = (char) q;
        l = l - q;
        return;
    }

    void sendResult()
    {
        long sum;
        atoi(Counter.get());
        uartTransmit(6c, buf);
        return;
    }

    void handleMessage(char length, char[] msg)
    {
        long l;
        //l = parseNum(length, msg);
        //atoi(l);
        //uartTransmit(6c, buf);
        Counter.init();
        l = parseNum(length, msg);
        //l = 10l;
        c1.chainInc(l, 10l);
        c2.chainInc(l, 10l);
        c3.chainInc(l, 10l);
        c4.chainInc(l, 10l);
        c5.chainInc(l, 10l);
        after 50l msec before 0l msec sendResult();
        return;
    }
}

*/

/*

extern void test(int);
extern void uartSetCallback(function (char, char[]) -> void);
extern void uartSend(char, char[]);

extern void toggleLed(void);

Main main;

MessageHandler msgHndlr;

Blinker blnkr;

class MessageHandler
{
    char[30] msgBuf;
    char[] ptr;
    char index;

    char toUpper(char c)
    {
        return c + (char) 40;
    }

    char test(char b)
    {
        char x;
        char y;
        char z;
        return x + y + z + b;
    }

    void handleMessage(char length, char[] msg)
    {
        ptr = msgBuf;
        ptr[(int)0] = (char) 2;
        toUpper(msg[(int) 0]);
        return;
    }

    void init()
    {
        index = (char) 0;
        return;
    }
}

class Main
{
    void main()
    {
        uartSetCallback(msgHndlr.handleMessage);
        return;
    }
}

class Blinker
{
    int nBlinks;
    long period;

    void startBlinking(int blinks, long argPeriod)
    {
        nBlinks = blinks;
        period = argPeriod;
        if(nBlinks > (int) 0)
            blink();
        return;
    }
    
    void blink()
    {
        after period msec before (long) 10 msec blink();
        return;
    }
}

*/

extern void setUartCallback(char[], function (char) -> void);
extern void uartTransmit(char, char[]);

object Random
{
    long X;

    void seed(long y)
    {
        X = y;
        return;
    }

    long getNext()
    {
        X = (2147483629l*X + 2147483587l) & 2147483647l;
        return X;
    }
}

object Player
{
    char direction;
    char[2] headPos;
    char[2] tailPos;

    void init(char x, char y, char dir)
    {
        direction = dir;
        headPos[0i] = x;
        tailPos[0i] = x;
        headPos[1i] = y;
        tailPos[1i] = y;

        return;
    }

    void setDirection(char dir)
    {
        direction = dir;
        return;
    }

    void move()
    {
        char tile;
        char taildir;
        Board.setTile(headPos[0i], headPos[1i], direction*10c + 1c);
        if(direction == 0c)
            headPos[0i] = headPos[0i] + 1c;
        else if(direction == 1c)
            headPos[1i] = headPos[1i] - 1c;
        else if(direction == 2c)
            headPos[0i] = headPos[0i] - 1c;
        else
            headPos[1i] = headPos[1i] + 1c;
        tile = Board.getTile(headPos[0i], headPos[1i]);
        if(tile < 10c)
            Game.finish();
        if(tile != 105c)
        {
            taildir = Board.getTile(tailPos[0i], tailPos[1i]) / 10c;
            Board.setTile(tailPos[0i], tailPos[1i], 0c);
            if(taildir == 0c)
                tailPos[0i] = tailPos[0i] + 1c;
            else if(taildir == 1c)
                tailPos[1i] = tailPos[1i] - 1c;
            else if(taildir == 2c)
                tailPos[0i] = tailPos[0i] - 1c;
            else
                tailPos[1i] = tailPos[1i] + 1c;
        }
        return;
    }
}

object Board
{
    char[400] board;
    char[100] updates;
    int updPos;

    void init()
    {
        int i;
        while(i < 400i)
        {
            board[i] = 0c;
            i = i + 1i;
        }
        updPos = 0i;
        return;
    }

    char getTile(char x, char y)
    {
        return board[(int) (y*20c + x)];
    }

    void setTile(char x, char y, char color)
    {
        board[(int) (y*20c + x)] = color;
        board[updPos] = x;
        board[updPos + 1i] = y;
        board[updPos + 2i] = color;
        updPos = updPos + 3i;
        return;
    }

    void update()
    {
        uartTransmit((char) updPos, updates);
        return;
    }
}

object Game
{
    long speed;
    bool running;
    char[20] input;

    void handleInput(char length)
    {
        if(length > 1c)
            return;
        Player.setDirection(input[0i]);
        return;
    }

    void setup()
    {
        setUartCallback(input, Game.handleInput);
        running = true;
        Board.init();
        Player.init(3c, 3c, 0c);
        speed = 250l;
        return;
    }

    void tick()
    {
        if(running)
            after speed msec tick();
        Player.move();
        Board.update();
        return;
    }

    void finish()
    {
        running = false;
        return;
    }
}

object Main
{
    void main()
    {
        Game.setup();
        after 2l sec Game.tick();
        return;
    }
}