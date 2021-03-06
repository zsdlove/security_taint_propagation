/**
 *
 */
package at.dallermassl.ap.security.taint.extension;

/**
 * Base implementation of TaintedObject interface.
 * @author cdaller
 *
 */
public abstract aspect AbstractTaintedObjectAspect implements TaintedObject {

    private boolean TaintedObject.tainted = false;
    // bit field of sources: cannot use any other types than "int" -> vm will not start otherwise!
    private int TaintedObject.sourceIdBitField = 0;
    private int TaintedObject.taintedObjectId = 0;
    private static int objectCounter = 0;


    public final boolean TaintedObject.isTainted() {
        return tainted;
    }

    public final void TaintedObject.setTainted(boolean tainted) {
//        System.out.println("set tainted to " + tainted);
        this.tainted = tainted;
        if (tainted) {
            initTaintedObjectId();
        }
    }

    public final int TaintedObject.getTaintedSourceIdBits() {
        return sourceIdBitField;
    }

    /**
     * Returns an int array of ids of the sources. The implementation uses the bit field
     * and creates an int array from it using the real ids (0-31) instead of the bit field.
     * @return an int array of ids or an empty array.
     */
    public final int[] TaintedObject.getTaintedSourceIds() {
        int count = 0;
        for (int bit = 0; bit < 31; bit++) {
            if ((sourceIdBitField & (1 << bit)) > 0) {
                count++;
            }
        }
        int[] ids = new int[count];
        int index = 0;
        for (int bit = 0; bit < 31; bit++) {
            if ((sourceIdBitField & (1 << bit)) > 0) {
                ids[index] = bit;
                index++;
            }
        }
        return ids;
    }

    public final void TaintedObject.addTaintedSourceIdBits(int sourceIds) {
        sourceIdBitField = sourceIdBitField | sourceIds;
    }


    public final void TaintedObject.setTaintedSourceIdBits(int sourceIds) {
        sourceIdBitField = sourceIds;
    }


    public final void TaintedObject.addTaintedSourceId(int sourceId) {
        if (sourceId > 30) {
            throw new IllegalArgumentException("Source id must be <= 30!");
        }
        int mask = 1 << sourceId;
        sourceIdBitField = sourceIdBitField | mask;
    }

    public final void TaintedObject.addTaintedSourceIds(int... sourceIds) {
        if (sourceIds != null) {
            for (int sourceId : sourceIds) {
                addTaintedSourceId(sourceId);
            }
        }
    }

    public final void TaintedObject.clearTaintedSourceIds() {
        sourceIdBitField = 0;
    }

    public final int TaintedObject.getTaintedObjectId() {
        return taintedObjectId;
    }

    private final void TaintedObject.initTaintedObjectId() {
        if (taintedObjectId == 0) {
            taintedObjectId = ++objectCounter;
//            if (objectCounter % 1000 == 0) {
//                System.out.println("TaintedObjectId: " + taintedObjectId);
//            }
        }
    }

    private final void TaintedObject.clearTaintedObjectId() {
        taintedObjectId = 0;
    }

}
