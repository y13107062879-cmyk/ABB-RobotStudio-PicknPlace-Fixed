MODULE Module1

    CONST robtarget g_sleep:=[[0.0,-191.78,311.54],[0,0,0.79335,0.60876],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget g_home:=[[620.91,0.0,791.0],[0.35355,-0.61237,0.61237,-0.35355],[0,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ref_peg:=[[200,500,50],[0,0.923879533,-0.382683432,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ref_plateA:=[[550,350,25],[0,-0.707106781,0.707106781,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ref_plateB:=[[400,-250,25],[0,-0.707106781,0.707106781,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget f_plateA:=[[525,325,25],[0,0.866025404,-0.5,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget f_plateB:=[[475.000398044,-275.000229832,25],[0,-0.5,0.866025404,0],[-1,0,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    CONST num SafetyZ_Offset:=150;
    CONST num Xinc:=-50;
    CONST num Yinc:=-50;
    VAR num Xpos:=0;
    VAR num Ypos:=0;
    PERS tooldata Gripper:=[TRUE,[[0,0,114.2],[1,0,0,0]],[0.215,[8.7,12.3,49.2],[1,0,0,0],0.00021,0.00024,0.00009]];

    PROC Path_log()
        MoveJ g_sleep,v400,z10,Gripper\WObj:=wobj0;
        MoveJ g_home,v600,z10,Gripper\WObj:=wobj0;
    ENDPROC

    PROC Path_sleep()
        MoveJ g_home,v600,z10,Gripper\WObj:=wobj0;
        MoveJ g_sleep,v400,z10,Gripper\WObj:=wobj0;
    ENDPROC

    PROC DoAttach()
        SetDO Attach,1;
        WaitTime 0.35;
        SetDO Attach,0;
        WaitTime 0.15;
    ENDPROC

    PROC DoDetach()
        SetDO Detach,1;
        WaitTime 0.35;
        SetDO Detach,0;
        WaitTime 0.15;
    ENDPROC

    PROC PicknPlace()
        MoveJ Offs(f_plateA,Xpos,Ypos,SafetyZ_Offset),v800,fine,Gripper\WObj:=wobj0;
        MoveL Offs(f_plateA,Xpos,Ypos,100),v600,fine,Gripper\WObj:=wobj0;
        MoveL Offs(f_plateA,Xpos,Ypos,50),v500,fine,Gripper\WObj:=wobj0;
        DoDetach;
        MoveL Offs(f_plateA,Xpos,Ypos,100),v800,fine,Gripper\WObj:=wobj0;
        MoveL Offs(f_plateA,Xpos,Ypos,50),v500,fine,Gripper\WObj:=wobj0;
        DoAttach;
        MoveL Offs(f_plateA,Xpos,Ypos,SafetyZ_Offset),v800,fine,Gripper\WObj:=wobj0;
        MoveL Offs(f_plateB,Xpos,Ypos,SafetyZ_Offset),v600,fine,Gripper\WObj:=wobj0;
        MoveL Offs(f_plateB,Xpos,Ypos,50),v500,fine,Gripper\WObj:=wobj0;
        DoDetach;
        MoveL Offs(f_plateB,Xpos,Ypos,SafetyZ_Offset),v800,fine,Gripper\WObj:=wobj0;
        MoveL Offs(f_plateB,Xpos,Ypos,50),v500,fine,Gripper\WObj:=wobj0;
        DoAttach;
        MoveL Offs(f_plateB,Xpos,Ypos,SafetyZ_Offset),v600,fine,Gripper\WObj:=wobj0;
    ENDPROC


    PROC main()
        Path_log;
        MoveJ Offs(ref_peg,0,0,500),v500,z50,Gripper\WObj:=wobj0;
        MoveL Offs(ref_peg,0,0,250),v400,z30,Gripper\WObj:=wobj0;
        MoveL Offs(ref_peg,0,0,50),v300,z10,Gripper\WObj:=wobj0;
        MoveL Offs(ref_peg,0,0,10),v200,fine,Gripper\WObj:=wobj0;
        DoAttach;
        MoveL Offs(ref_peg,0,0,100),v500,z20,Gripper\WObj:=wobj0;
        MoveL Offs(ref_plateA,0,0,150),v500,z10,Gripper\WObj:=wobj0;

        FOR Y FROM 0 TO 2 DO
            FOR X FROM 0 TO 2 DO
                PicknPlace;
                Xpos:=Xpos+Xinc;
            ENDFOR
            Ypos:=Ypos+Yinc;
            Xpos:=0;
        ENDFOR
        Ypos:=0;
        MoveJ Offs(ref_peg,0,0,250),v800,z30,Gripper\WObj:=wobj0;
        MoveL Offs(ref_peg,0,0,50),v500,z10,Gripper\WObj:=wobj0;
        MoveL Offs(ref_peg,0,0,10),v200,fine,Gripper\WObj:=wobj0;
        DoDetach;
        MoveL Offs(ref_peg,0,0,50),v500,z10,Gripper\WObj:=wobj0;
        MoveL Offs(ref_peg,0,0,150),v800,z30,Gripper\WObj:=wobj0;
        Path_sleep;
    ENDPROC
ENDMODULE
