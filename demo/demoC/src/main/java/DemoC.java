import com.tmtron.ex.dsla.ModelA;
import com.tmtron.ex.dslb.ModelB;
import com.tmtron.ex.dslc.ModelC;

public class DemoC {
  public void Test() {
	  ModelA.fieldA = 10L;
	  
	  ModelB.fieldA = 11L;
	  ModelB.fieldB = "B";
	  
	  ModelC.fieldA = 12L;
	  ModelC.fieldB = "C";
	  ModelC.fieldC = -12;
  }
}
