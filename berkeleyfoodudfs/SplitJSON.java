package berkeleyfoodudfs;

import java.io.IOException;
import java.util.Arrays;
import org.apache.pig.EvalFunc;
import org.apache.pig.data.Tuple;
import org.apache.pig.data.TupleFactory;
import org.apache.pig.data.DataType;
import org.apache.pig.impl.logicalLayer.schema.SchemaUtil;
import org.apache.pig.impl.logicalLayer.schema.Schema;
import org.apache.pig.impl.logicalLayer.schema.Schema.FieldSchema;
import org.apache.commons.logging.Log;

import com.google.gson.Gson;

public class SplitJSON extends EvalFunc<Tuple> {
    TupleFactory mTupleFactory = TupleFactory.getInstance();

    public Tuple exec(Tuple input) throws IOException {
        if (input == null || input.size() == 0) {
            return null;
        }

        try {
            String str = (String)input.get(0);
            Gson gson = new Gson();
            Tweet tweet = gson.fromJson(str, Tweet.class);
            Tuple tuple = mTupleFactory.newTuple();
            addFieldsToTuple(tweet, tuple, str);
            return tuple;
        } catch (Exception e) {
            throw new IOException("Caught exception processing input row ", e);
        }
    }

    protected void addFieldsToTuple(
            Tweet tweet, Tuple tuple, String originalText) {
        // getLogger().info("Tweet ID: " + tweet.idStr);
        tuple.append(tweet.idStr);
        if (tweet.coordinates != null) {
            tuple.append(tweet.coordinates.coordinates[0]);
            tuple.append(tweet.coordinates.coordinates[1]);
        } else {
            tuple.append(null);
            tuple.append(null);
        }
        tuple.append(originalText);
    }

    public Schema outputSchema(Schema input) {
        try {
            return SchemaUtil.newTupleSchema(
                new String[]{"id_str", "lon", "lat", "json"},
                new Byte[]{
                    DataType.CHARARRAY,
                    DataType.DOUBLE,
                    DataType.DOUBLE,
                    DataType.CHARARRAY
                });
        } catch (Exception e) {
            return null;
        }
    }

    /* WIP */
    /*
    protected Schema forEachClass(Class c, Schema s) {
        Map<String,Byte> typeNamesToBytes = Data.genNameToTypeMap();
        for (Field field : cls.getDeclaredFields()) {
            if (!Modifier.isStatic(field.getModifiers())) {
                out.add(new FieldSchema(field.getName(),
                                        typeNamesToBytes.get(
                                            field.getType().getName())));
            }
        }

        for (Class c : cls.getDeclaredClasses()) {
            Schema inner = forEachClass(c, new Schema());
        }
    }
    */
}
