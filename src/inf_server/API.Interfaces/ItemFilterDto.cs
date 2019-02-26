namespace API.Interfaces
{
    partial class ItemFilterDto
    {
        public static bool operator ==(ItemFilterDto first, ItemFilterDto second)
        {
            if (first is null)
            {
                return second is null;
            }
            else if (second is null)
            {
                return false;
            }

            return first.Equals(second);
        }

        public static bool operator !=(ItemFilterDto first, ItemFilterDto second) =>
            !(first == second);
    }
}
